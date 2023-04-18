class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.63.0",
      revision: "e3caa6d6c736ae28b82967307cdc2ab72afa9ce8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a689bf20b1ab2aa4ff765174fc861e78315e9300d29457b1b55cf876bd466583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cefef6baa126ac06593e7bbad2ca9cfe5c58c07b9c13756bde1611ba5afd3e80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6929fe68221e8344224d4cbd84a5e001e298c155ca521be212974d13e74d6eeb"
    sha256 cellar: :any_skip_relocation, ventura:        "5c11e1a9c4fe52c865da4ffa73b2bb1c92ee79157b13a68c5ede1aa9de712d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "d257a4c181e0cef1201a783d681476dc8b74d8482ec60bcc5fd1766fc3eb5a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fc31a110923f89044c109960fa0303414e7b06c3b679340cf09d0a336b6a4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a14c9aa078a384e9e8a6fa88334d004d2d16b1de3ead22c7705ead033e238a"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
