class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.3.0.tar.gz"
  sha256 "7f8f80a0b9fc03f8481c56365d043b927a85c87543fcf83aa212443c2fc3ca4a"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed467d8830a6c6ef79ec7539678e2dc387eb2293e92ca267b6e7593ebf7a7424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ccd44e59358e6bcd74d170acc69d1154175cc15da60660b50d715ea3c797fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d023cad235e9f112864907c999ea0a215db91b91388483ec56942ce3d8db873a"
    sha256 cellar: :any_skip_relocation, ventura:        "e99c12d1b948a6de9e0240168279d3d78334336deb71780d103d549b6888463f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f46e80e1835a5b1052ecd803915f44bfd3a34110f193739140c0916aca6a0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddf779964cfd6321e16d33c18d7eb6bbe95f65502e58b2db88a6f940662f1df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716638d1f0ec97c6b06f5b6642e7a526a6b23a5fa5e2b6bbc479dab0ddcfa863"
  end

  depends_on "go" => :build

  # Fix kIOMasterPortDefault symbol rename.
  # Remove when github.com/shoenig/go-m1cpu is bumped to v0.1.5 or newer.
  # Check: https://github.com/projectdiscovery/httpx/blob/main/go.mod#L110
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end

__END__
diff --git a/go.mod b/go.mod
index 7f6ccae..4b8efe6 100644
--- a/go.mod
+++ b/go.mod
@@ -107,7 +107,7 @@ require (
 	github.com/saintfish/chardet v0.0.0-20230101081208-5e3ef4b5456d // indirect
 	github.com/sashabaranov/go-openai v1.8.0 // indirect
 	github.com/shirou/gopsutil/v3 v3.23.3 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/syndtr/goleveldb v1.0.0 // indirect
 	github.com/tidwall/btree v1.6.0 // indirect
 	github.com/tidwall/buntdb v1.2.10 // indirect
diff --git a/go.sum b/go.sum
index 097dd4e..797f347 100644
--- a/go.sum
+++ b/go.sum
@@ -241,8 +241,9 @@ github.com/sashabaranov/go-openai v1.8.0 h1:IZrNK/gGqxtp0j19F4NLGbmfoOkyDpM3oC9i
 github.com/sashabaranov/go-openai v1.8.0/go.mod h1:lj5b/K+zjTSFxVLijLSTDZuP7adOgerWeFyZLUhAKRg=
 github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQgSEE=
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
-github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/sirupsen/logrus v1.3.0/go.mod h1:LxeOpSwHxABJmUn/MG1IvRgCAasNZTLOkJPxbbu5VWo=
