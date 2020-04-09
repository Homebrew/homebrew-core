class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.17.0.tar.gz"
  sha256 "65b03ae322c4d3ed47f502866b4da2b2c7029b6cb5dc989e98664d564a57de1d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1b8e0284a229f80ae87e49e3d8b921c343e3dd6d674a8f065a1e495725ff48b5" => :catalina
    sha256 "14d093c826b92b4839c5ffa1c9a33d2bf85b46f31a0ea7a87d69f6c6b068788c" => :mojave
    sha256 "32c4bbfc324a5382726aa4d90e30338a646aae14c91c17e9b204925a6afdbf37" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
