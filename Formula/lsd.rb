class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.15.0.tar.gz"
  sha256 "e12b4472b174c3d5669a110331f5c1040472824f1e85bf44dc008fff4218d44f"

  bottle do
    cellar :any_skip_relocation
    sha256 "28412d1195f68fcd90498378d36b727fc5a266f95b9ce56ca941e6d40081b738" => :mojave
    sha256 "414b5fe9e809e3641b7930ce900e744c9407f062d962327508b092fb3359b982" => :high_sierra
    sha256 "cbae4e055f8a92d1513da4f65f91dde6b7e2e9ca94729f959973e89187d5cae4" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
