class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.30.0.tar.gz"
  sha256 "c44fd80060312701c0f6cbb36eff1229a3e4fd252a37db62f268002350c7a65c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6d40adc81a61f454efd49a968cb49b9cdc568977cd40b6ef12d9baa8378eb25" => :catalina
    sha256 "9335de385a997c26aa1ac0552b0a4082ea5b2a5332cd27286b538574ed470549" => :mojave
    sha256 "948ae1ed0dc24b2f400f4e58fe3438371d4663db0c7ff62f7634d6cc5fa31d0c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
