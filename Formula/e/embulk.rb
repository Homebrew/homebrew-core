class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  # https://www.embulk.org/articles/2020/03/13/embulk-v0.10.html
  # v0.10.* is a "development" series, not for your production use.
  # In your production, keep using v0.9.* stable series.
  url "https://github.com/embulk/embulk/releases/download/v0.11.2/embulk-0.11.2.jar"
  sha256 "382d2408fa662d736a8e97d387cf5f8b8b1f21d69a9cdd3e1922653b056316b3"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{(?<!un)Stable.+?href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, monterey:     "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, big_sur:      "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f18e539ca70420cd3cc6fb7f7b24cc1d761ecb9cf7af7121d576a0727a17586f"
  end

  depends_on "openjdk@8"

  def install
    libexec.install "embulk-#{version}.jar"
    bin.write_jar_script libexec/"embulk-#{version}.jar", "embulk", java_version: "1.8"
  end

  test do
    system bin/"embulk", "example", "./try1"
    # we skip the "embulk guess" command from the documentation because it triggers
    # a permission request on mac, instead we write the config.yml file ourselves
    config_file = testpath/"config.yml"
    config_file.write <<~EOS
      in:
        type: file
        path_prefix: #{testpath}/./try1/csv/sample_
        decoders:
        - {type: gzip}
        parser:
          charset: UTF-8
          newline: LF
          type: csv
          delimiter: ','
          quote: '"'
          escape: '"'
          null_string: 'NULL'
          trim_if_not_quoted: false
          skip_header_lines: 1
          allow_extra_columns: false
          allow_optional_columns: false
          columns:
          - {name: id, type: long}
          - {name: account, type: long}
          - {name: time, type: timestamp, format: '%Y-%m-%d %H:%M:%S'}
          - {name: purchase, type: timestamp, format: '%Y%m%d'}
          - {name: comment, type: string}
      out: {type: stdout}
    EOS
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
