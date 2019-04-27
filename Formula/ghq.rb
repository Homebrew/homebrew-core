class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.10.0.tar.gz"
  sha256 "3384dcf14c710405cd66584aa52bb08a85334d70beb4a62b5a4c45af527948c8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f3b7bcd4d98836a3f67be418ec2a6edf2c8c772095180e0f1fb40a069383e435" => :mojave
    sha256 "fc0268e02a7317756f6460d449abd37001f647d7ac0ced3689100a6d81d52605" => :high_sierra
    sha256 "49b5d6f977404242bd93df665bcd45488017ae14f4ebaef47bc03da3bc62c765" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
