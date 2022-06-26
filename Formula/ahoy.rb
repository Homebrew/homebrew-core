class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/2.0.0.tar.gz"
  sha256 "cc3e426083bf7b7309e484fa69ed53b33c9b00adf9be879cbe74c19bdaef027c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e46722a7462714b2365104084a2da3200d8517f2211bac3341803b0fdc38b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d677fd11b20884b0ee00a028d6d8983e3eb88f006de381bd2d59c156215158d"
    sha256 cellar: :any_skip_relocation, monterey:       "789a5ed82fd38438338df61f878454675adab3719fa7063707e185784cfda190"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d796f66f413571680fa23532f3f1384670daa4cff4d91e5b05ff3b0ca478462"
    sha256 cellar: :any_skip_relocation, catalina:       "fb8e03826f9109edc8bb5b1e0c7c9d8054d76e364bca13e0afdf7a23b022a817"
    sha256 cellar: :any_skip_relocation, mojave:         "eabaf2c0faa64d878f3fd552823b9d5103e0755ba5f3120628e605964fc93257"
    sha256 cellar: :any_skip_relocation, high_sierra:    "93db889b646270f7a92d32f649c9e256e4e90cfa006a04c614334f28557ce7ca"
    sha256 cellar: :any_skip_relocation, sierra:         "5743854a4e6553adb3318a2facfd941bcf4d95a7ab3c2399400c7818c6e19c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6388f35dab72772d6fe2cb701b46717f3ac9435023f1a5b51747dee36568b97b"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    bin_path = buildpath/"src/github.com/ahoy-cli/ahoy"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-o", bin/"ahoy", "-ldflags", "-X main.version=#{version}", "."
    end
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`
  end
end
