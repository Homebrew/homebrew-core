class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.8.0.tar.gz"
  sha256 "cbf660b083d162d0b8edd99fd320b56838dd7444099cf1988104d5b96d4c681b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb0ac6320fe9f43f1730324ff10cad256b92540790aa06b86d992d21d445359d" => :catalina
    sha256 "0dc267ba57be2e1bd11ddcb294bbc8561020b8a420cd2178f0e13b65835cc77c" => :mojave
    sha256 "278e1f1da1694e4248777f00d8b8270169c1401d99deac0a2344a05fb24f2e30" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
