class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.85.0",
      revision: "858af4d820fa4332671b1cd8012660ab9870efbb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2da7d7838162edde1aac4fe306086c0cfe2f98df7e1be5a0fe135d129246379"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b7dc42b7829d43ee7bade579a29db8ab75e77bf0b76b695b4a867c37c5bbc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd1642a0f72ef122b848e293bdb1c5fa3886d6eefd56b0f89a40d6b24368526a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "449aee631e5fd55848eb1d050b77b448420b6fcc7ba0a6ff4e178073e2e3e552"
    sha256 cellar: :any_skip_relocation, sonoma:         "0132ffbea9a880b426fb6096dfb2819971fa8c07d974b32eae118239a6b71751"
    sha256 cellar: :any_skip_relocation, ventura:        "718e324489a4614123773cc92853737b11a23cbe81c37a9d56cda87a8f5be739"
    sha256 cellar: :any_skip_relocation, monterey:       "d69b3c112cca3a493a6609c4f64a58163dd02b8c92c23a08d894778a6a286a08"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f6bcb05b848de1ba8eef84d8a46e13b3bef438e7b387dc9994d85941a4ee082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c80af7785997751e0a3ec9ca6ece119e69dd679ac1434a9d8f0cf003d9cda71"
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
