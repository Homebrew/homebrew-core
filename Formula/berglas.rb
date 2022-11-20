class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.1.tar.gz"
  sha256 "be619fe870249e74f52076d16020808b6020fedf2b98685f7c14145a291a2fe7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1f9664db94c8efe45ac102d87cfe1eaa89000c2908de2921f31f629d26a4f52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d392721ea8471cfa11db1f2d7e6781b1fbad2114529489fe60c432161d95c02b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20b103e06f0d92f809dfc42e2c0f949dad8f214279449599d230f287e9a7f8b7"
    sha256 cellar: :any_skip_relocation, ventura:        "cb18df89e0d167a22b4efae883ac1795c43c86a7677161c5daf6111df7bb76a0"
    sha256 cellar: :any_skip_relocation, monterey:       "216c3bcbe16588242e0921ee73fbd11cedae215427e05909ef0274f0b890990f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c89e0016996ddb7847a2bfdb4b7c7e7d04801932a9d08dc537c55f2927e2053"
    sha256 cellar: :any_skip_relocation, catalina:       "38b91df56e0944b6169d27c50ff6fb92fa433febc63e2d907781056754d3310d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2e2be5ea59902755712114403d39c131830f05098405b1bfc056e0b1868161"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
