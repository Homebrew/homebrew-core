class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v5.0.1.tar.gz"
  sha256 "df733e8d79b2ab2778a6c72973c76ee59b3f686a4c35b3d0850d523c96c062c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc5d872cf00a242ec46f7fc4e8476f8c3acb5b92855b1963661b8d86ad54daa1" => :catalina
    sha256 "c6c294aff1a1a12c556ca5da21ba4ab513e7ea6bfba93d478d76bd1d766870e7" => :mojave
    sha256 "5738f417ecb70edaa27eb76b5365da33f3d282166ea5230db38de89c11dc8b3e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
