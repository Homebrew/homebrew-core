class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.97.3.tar.gz"
  sha256 "22ea1f689060edf10ee533047f553ad1c558209ea642687998f4ccb465faa9fc"
  license "MIT"

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"
  end

  def install
    # Tell the pub server where these installations are coming from.
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    system "dart", "compile", "exe",
                   "-Dversion=#{version}",
                   "-Dcompiler-version=#{version}",
                   "-Dprotocol-version=#{resource("language").version}",
                   "bin/sass.dart",
                   "--output", "sass"
    bin.install "sass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version") if OS.mac?

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
