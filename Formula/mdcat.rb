class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.21.0.tar.gz"
  sha256 "6093ac86cffce76752d2fc7e60b147514b2f037fd193b0bfad7e3d700a9c4610"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4708fb158650a61061fac6f3d9c0fad32a99bfb9a83694e2bc5a8b0f2caf158" => :catalina
    sha256 "f09e16f34bae0f7560dce8de9bf2aca9cd8c09acab4440eac1ee5838aaca9304" => :mojave
    sha256 "180920ccc7122e8cfb91407a7aac3f73012c252dd4d7125fd23a6bfe612f1b56" => :high_sierra
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
