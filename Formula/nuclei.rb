class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.5.tar.gz"
  sha256 "1a54899057f84cb6f837fb7e41db5cfdf6fdcebb79389e1d048f1f03d381bd00"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108adbcc9baa1eed8a34db78ff89dc571babebdb0acd4fe5d04c9bb6defa2fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b28bb6a8d7606de7ddbb584cddfd7d331d1740fd3dc850bdcaa677400352f03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a637a9b17dbf21db836afe9898c779336c9c888bf04a673113aa434b54911952"
    sha256 cellar: :any_skip_relocation, ventura:        "503c009bf361249f362445fa7b4504f46b591101c041ae8586daebb3cd5e0f38"
    sha256 cellar: :any_skip_relocation, monterey:       "262c0c6d888df4219969a78d7185339e93535001266c3ae6bee10a8b5211eea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b8ed80c50c170f6840aa607e517191068045aab549cdcea853e8961c6809f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c2240cb02be9bc04ab397e7e04f5670669493c999ccc5d12544d7b41ccc913"
  end

  depends_on "go" => :build

  # Fix kIOMasterPortDefault symbol rename.
  # Remove when github.com/shoenig/go-m1cpu is bumped to v0.1.5 or newer.
  # Check: https://github.com/projectdiscovery/nuclei/blob/v#{version}/v2/go.mod
  patch :DATA

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml", "-config-directory", testpath
  end
end

__END__
diff --git a/v2/go.mod b/v2/go.mod
index ae37aaa..fe3048f 100644
--- a/v2/go.mod
+++ b/v2/go.mod
@@ -126,7 +126,7 @@ require (
 	github.com/projectdiscovery/cdncheck v1.0.1 // indirect
 	github.com/projectdiscovery/freeport v0.0.4 // indirect
 	github.com/sashabaranov/go-openai v1.8.0 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/skeema/knownhosts v1.1.0 // indirect
 	github.com/smartystreets/assertions v1.0.0 // indirect
 	github.com/tidwall/btree v1.6.0 // indirect
diff --git a/v2/go.sum b/v2/go.sum
index fa2367e..c470cd3 100644
--- a/v2/go.sum
+++ b/v2/go.sum
@@ -473,8 +473,9 @@ github.com/sergi/go-diff v1.2.0 h1:XU+rvMAioB0UC3q1MFrIQy4Vo5/4VsRDQQXHsEya6xQ=
 github.com/sergi/go-diff v1.2.0/go.mod h1:STckp+ISIX8hZLjrqAeVduY0gWCT9IjLuqbuNXdaHfM=
 github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQgSEE=
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
-github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/sirupsen/logrus v1.3.0/go.mod h1:LxeOpSwHxABJmUn/MG1IvRgCAasNZTLOkJPxbbu5VWo=
