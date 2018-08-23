class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.8.2.tar.gz"
  sha256 "475cecc8cc12bddfe6d58311e3e084fb1583647b1902c8955d45adba1d22a273"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = ENV["PATH"] + ":" + buildpath + "/bin"

    dir = buildpath/"src/github.com/open-policy-agent/opa"
    dir.install Dir["*"]

    system "make", "deps", "-C", dir
    system "make", "-C", dir

    opa_bin = dir/"opa_darwin_amd64"
    mv opa_bin, dir/"opa"
    bin.install(dir/"opa")
  end

  test do
    system "echo", "pi = 3.14", "|", "#{bin}/opa", "eval", "--stdin"
  end
end
