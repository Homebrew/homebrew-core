class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.8.1.tar.gz"
  sha256 "d10d412c71dea51b4973c3ded5de1503a4c5de8751be5050de989ac08eb0455e"
  license "MIT"
  head "https://github.com/simeg/eureka.git"

  bottle do
    cellar :any
    sha256 "1aee228a339009bb98020df8f499f27353dc1bd4d301d357b86e130d0d17d906" => :big_sur
    sha256 "90360b05ad3ef835c82c534e68ec79ad930eb2b0c6dafa635340f994851ce72b" => :arm64_big_sur
    sha256 "b8fa76b3d16fb92968402f2057693af133270c72292307461f351b8950b9b329" => :catalina
    sha256 "2d31715b3b5aa38ed008b58e83d9ce6c9afdbe58f9f6d4bb3bf9195f3dc139ed" => :mojave
    sha256 "060f76e2626e9b30184f1cfe0a61f8b4ddf545c8f8a5d59c6a8d1b54f9548c4a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "homebrew/README.md: No such file or directory", shell_output("#{bin}/eureka --view 2>&1")
  end
end
