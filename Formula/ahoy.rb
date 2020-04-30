class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/2.0.0.tar.gz"
  sha256 "cc3e426083bf7b7309e484fa69ed53b33c9b00adf9be879cbe74c19bdaef027c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb8e03826f9109edc8bb5b1e0c7c9d8054d76e364bca13e0afdf7a23b022a817" => :catalina
    sha256 "eabaf2c0faa64d878f3fd552823b9d5103e0755ba5f3120628e605964fc93257" => :mojave
    sha256 "93db889b646270f7a92d32f649c9e256e4e90cfa006a04c614334f28557ce7ca" => :high_sierra
    sha256 "5743854a4e6553adb3318a2facfd941bcf4d95a7ab3c2399400c7818c6e19c6f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
