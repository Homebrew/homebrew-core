class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://www.graylog.org/"
  url "https://github.com/Graylog2/collector-sidecar.git",
    tag:      "1.1.0",
    revision: "89c722567033ea48b42678d2303693aa6ddee775"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24494acc03245693ab94d61f3aa8903b1006243713fa3fac91e499c7de885b44"
    sha256 cellar: :any_skip_relocation, big_sur:       "689ede327bbf176b9c4f3d544f90f5940b1d026151b91c50a0100edd268c48ec"
    sha256 cellar: :any_skip_relocation, catalina:      "30f35fc66f276071c2126fbe77f7bb7b3a7852a1c45adc2d5532a8340b421902"
    sha256 cellar: :any_skip_relocation, mojave:        "193227a80963772b7a480713f3d104fe9e3a1dc7e1c7122a26292fd5bf5c0708"
  end

  depends_on "go" => :build
  depends_on "mercurial" => :build
  depends_on "filebeat"

  def install
    ldflags = %W[
      -s -w
      -X github.com/Graylog2/collector-sidecar/common.GitRevision=#{Utils.git_head}
      -X github.com/Graylog2/collector-sidecar/common.CollectorVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"graylog-sidecar"
    (etc/"graylog/sidecar/sidecar.yml").install "sidecar-example.yml"
  end

  plist_options manual: "graylog-sidecar"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_bin}/graylog-sidecar</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-sidecar -version")
  end
end
