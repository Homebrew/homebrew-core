class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.20.0.tar.gz"
  sha256 "c62e3fbe7461410b72b3fd27dcaa543aa0bec99cbfd78c87aa8fe441972e79ff"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "db4b660b7c98bbfad7e97bc49e0202df69dac3af72e3b1186f8e6a715860a1ad" => :catalina
    sha256 "70c41663a9c9f77a156eb0b7324d32be397ceef0343c5e42a01bd30e8947e88e" => :mojave
    sha256 "ef9bf2c8c6313e379215f70151e5dea9d58ac4837e09fb527162abda85807a07" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
