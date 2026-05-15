class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.99.0.tar.gz"
  sha256 "5f969b2eedf86384d90a9a339824b6652a4600e9e5f32784a7e48e453e145016"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04b68917e5fa15257e4015a7464bd866627c4676c48f0c9c4f42cbdff47c8f10"
    sha256 cellar: :any,                 arm64_sequoia: "504e7c9ab687facfd63978bb335f3bc3cddaedb5c0494093e13b503a0f055d21"
    sha256 cellar: :any,                 arm64_sonoma:  "d0ea9ce1bd01db3b76a7c64edb75da8716883d1eca1e7d9e62a11ebcb4e28b6b"
    sha256 cellar: :any,                 sonoma:        "74939be86282ef7692b4d0460af6a819aebe8de9efa2ca53d4bff5641bbeb485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1452e98b3a7c6bfd511cb657a9e91e709bfc60da565c18b77b6ef8f17c70858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedfbfb2a3ac93d3a27c965fe8b235ad56d5b17e3a5396660dac891a01e99ec6"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"
  end

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    args = %W[
      -Dversion=#{version}
      -Ddart-version=#{Formula["dart-sdk"].version}
      -Dcompiler-version=#{version}
      -Dprotocol-version=#{resource("language").version}
    ]
    system "dart", "compile", "aot-snapshot", "--output", "sass.aot", *args, "bin/sass.dart"
    libexec.install "sass.aot"

    (bin/"sass").write <<~BASH
      #!/bin/bash
      exec "#{Formula["dartaotruntime"].opt_bin}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end
