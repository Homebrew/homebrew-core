require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.5.0.tar.gz"
  sha256 "9cfb4115570aef268f77bdd89095bc0d144aeebff8646ba665bd4eafb326e338"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fceac06a83052ab1a67a5845ebc910438105e543677756c774c05b3a03a81c8" => :mojave
    sha256 "0b0552a903e6a0a29fbf38c1d2110263df22fd5a12599e36cd60b22bc1dab71e" => :high_sierra
    sha256 "1e3250586c714b629398dc02cd1b8168fe0cfe70a8a067d700b8b425f16d2ffa" => :sierra
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end

__END__
diff --git a/go.mod b/go.mod
index 5939f2b..fccc5e1 100644
--- a/go.mod
+++ b/go.mod
@@ -50,3 +50,5 @@ replace github.com/altoros/gosigma => github.com/juju/gosigma v0.0.0-20200420012
 replace gopkg.in/mgo.v2 => github.com/juju/mgo v0.0.0-20190418114320-e9d4866cb7fc

 replace github.com/hashicorp/raft => github.com/juju/raft v2.0.0-20200420012049-88ad3b3f0a54+incompatible
+
+replace golang.org/x/sys => golang.org/x/sys v0.0.0-20200826173525-f9321e4c35a6
