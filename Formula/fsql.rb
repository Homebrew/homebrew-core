class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.1.0.tar.gz"
  sha256 "7b27588e03127055b40f2a2ef4f554e86684bbdd1a4ef45cdad53f48ec9047e4"

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/kshvmdn"
    ln_s buildpath, buildpath/"src/github.com/kshvmdn/fsql"

    ENV["GOPATH"] = buildpath
    system "go", "build", "-o", "fsql"
    bin.install "fsql"
  end

  test do
    output = shell_output(bin/"fsql -version")
    assert_match "fsql v0.1.0", output
  end
end
