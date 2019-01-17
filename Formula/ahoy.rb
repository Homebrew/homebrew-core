class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "http://www.ahoycli.com/"
  url "https://github.com/ahoy-cli/ahoy/archive/2.0.0.tar.gz"
  sha256 "cc3e426083bf7b7309e484fa69ed53b33c9b00adf9be879cbe74c19bdaef027c"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/ahoy-cli/ahoy"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-o", bin/"ahoy", "-ldflags", "-X main.version=#{version}", "."
    end
  end

  def caveats; <<~EOS
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
