class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.2.tar.gz"
  sha256 "e197a221c2970328849445a946f2057754406507e2d7708ba85055fc989e199f"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280f76df5e62cc6fab4b8fb3925c398c480c60f28937d168ea0312c2d2c25566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b01e3165c376b072009e04b62d849e140afcfdd0f29e80a8d3798ba44e82bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "161953d5cec07350cd0967a6249484242e071cc05e44514371a4e42ac86156de"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd48b8fe3372d64d9782aa33406051109a722aed970c27b6e7a852868d4dc15"
    sha256 cellar: :any_skip_relocation, monterey:       "d788a751f4416af1e92d2e1f8fd382b05b0e5b86ca43baa86a1b8feccddc5962"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b37afbadf6756c567e8998df84d3a479801472c05bce2f956a17d6bec95104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce59e81f9149270c1e1004fc6673bc434b7d65ac945e41a9c06876cca3435d0"
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
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end

__END__
--- a/v2/go.mod
+++ b/v2/go.mod
@@ -125,7 +125,7 @@ require (
 	github.com/projectdiscovery/asnmap v1.0.2 // indirect
 	github.com/projectdiscovery/cdncheck v0.0.4-0.20220413175814-b47bc2d578b1 // indirect
 	github.com/projectdiscovery/freeport v0.0.4 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/skeema/knownhosts v1.1.0 // indirect
 	github.com/smartystreets/assertions v1.0.0 // indirect
 	github.com/tidwall/btree v1.6.0 // indirect
--- a/v2/go.sum
+++ b/v2/go.sum
@@ -476,6 +476,8 @@ github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQ
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
 github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/sirupsen/logrus v1.3.0/go.mod h1:LxeOpSwHxABJmUn/MG1IvRgCAasNZTLOkJPxbbu5VWo=
