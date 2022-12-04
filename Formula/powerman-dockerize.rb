class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "2b218fa1272efa78455f16f6e9b686090fe68263a1ee471f677fd3e0e5c77bce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a990f6b8bac33e5002be13cbdaea5bfa719c22d18211a846d88c6a5e755c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8642d0c12f327e67adc39a35cc0090e6104b7c45a1c76f298c3a628d0ce2fc81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "629931a80f250d3ba752ffc3cac7f2a3e0fe22b64acaf83a9e7ca89fa9f1013b"
    sha256 cellar: :any_skip_relocation, ventura:        "ea5dacb9e5dd17bbe6d225de2ade424429526bf1f08cda85da7c8015c6c7793a"
    sha256 cellar: :any_skip_relocation, monterey:       "b198f6fe1903346a08094580f67a39992efef4af256839ccb459f0c140a6fe0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "17adffb61cc731ad5a9488df5a91aecf78d9385bded4aca98505abaf0135756e"
    sha256 cellar: :any_skip_relocation, catalina:       "276d36926bfc3a980148363e01a4fe0e891580e8dbb2e14c8a122913457f4446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da1b5385f25681e3af2aae439e15594809f4c2f9c3ab1dcc8d20c0ac4cfd9e3"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
