class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7.4",
      :revision => "c8adaa920a8e0fe0cc172868a3811e643661f19e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ed7a928d2a93a05441b28560c2d0bf6a8ac58278313966c286e2d5d8703dd04c" => :catalina
    sha256 "7e6904339596de03b73b9a7e9fd4fcb99bc3e17e7188de4305d0367af09094aa" => :mojave
    sha256 "41f35cdbf18a012b7160ec10164ce66d4aedba2d9601f34d3cf0e93afa569528" => :high_sierra
    sha256 "cc0ea7892e0615a0e6d8b02573334cb3759cafd9abf81c2cb55fbddb68979f44" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
