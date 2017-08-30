class Gam < Formula
  desc "Command-line management for Google G Suite"
  homepage "https://github.com/jay0lee/GAM/wiki"
  url "https://github.com/jay0lee/GAM/archive/v4.30.tar.gz"
  sha256 "846b2902fe36019a9f4ebd4a911e780e103fb2d210971b8a4e407ddb6d8db4f6"
  head "https://github.com/jay0lee/GAM.git"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"src/gam.py" => "gam"
  end

  test do
    assert_equal "GAM 4.30 - https://git.io/gam", shell_output("#{bin}/gam | grep 'GAM 4.30'").chomp
  end
end
