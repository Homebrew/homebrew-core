class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e6173fe04b027c500759455745cc9f5d9e6317c4f523d7f8c187e3220d841dc4"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a308645bd3a205621ad677299c9e2253517b364bb5b87061bdfba0e014cb1f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d16bd8fc115e2f2df46660f43e83609dd53e7399199758ced30cfd7cb287859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de671c7ee2bff417c5542cbd3de116dc75e0e21cff60aced178ef8b27fb2307"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d74d1df04b78de4e4a2164e37fa6484119b9fdabf511eb0dd29012fe1c1c3d4"
    sha256 cellar: :any_skip_relocation, ventura:        "fb511bb169d734095eb8d0e2f337350596dd380d5d30b4fb9501467634ced6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "db4488f034b342c7d6dc989112fa288e6ef981c6f88a5e3646dd63f6254abb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5db81489adf14f9de8dafd11de8b9de58d62806f07c212a5fc7eb2c292976f3a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bounceback"

    pkgshare.install "data"
    # update relative data path to homebrew pkg path
    inreplace "config.yml" do |s|
      s.gsub! " data", " #{pkgshare}/data"
    end
    etc.install "config.yml" => "bounceback.yml"
  end

  service do
    run [opt_bin/"bounceback", "--config", etc/"bounceback.yml"]
    keep_alive true
    working_dir var
    log_path var/"log/bounceback.log"
    error_log_path var/"log/bounceback.log"
  end

  test do
    fork do
      exec bin/"bounceback", "--config", etc/"bounceback.yml"
    end
    sleep 2
    assert_match "\"message\":\"Starting proxies\"", (testpath/"bounceback.log").read
    assert_match version.to_s, shell_output("#{bin}/bounceback --help", 2)
  end
end
