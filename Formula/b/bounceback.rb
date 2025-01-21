class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6d65d82fc702728aecab608fff8437f4920c4deeea18351e9978f0f400e64ca7"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c204ee25c401ffe9a3755ed131a84fa34b65aa08fcebb6438ac2102893a38f72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0376b68002fbcfdc2dfed3fa9cab94cfaa8c81fa6e4fbe81964cd51ae99f428c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07be63668fea95277e1dfc474dfda6f49645bcb1e024bcebc22995ba60ae2491"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4d186fe33acd339d8782897a16bcdef1677296c9fc8e0dd517f7ac1455de68"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ff969438b2dbf80d762d79d9be4d5d3057a6fd16501aa3a9d64525863350386"
    sha256 cellar: :any_skip_relocation, ventura:        "489f7fbe868db0acbeb2ba5a655174a1c73edcb3a350d8bba163e3a54276f438"
    sha256 cellar: :any_skip_relocation, monterey:       "b349939b90fc5ca637cfbb9780e3cfc48179f5a86ab5794f0b3fa9cd7beb08c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834127906e053cf93616455abd4489179cd434a50377278575d1344d07c74dff"
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
