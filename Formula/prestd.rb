class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.2.5.tar.gz"
  sha256 "9899e7cc3188a42cdd8702a2547dc37dc6a37659a17d169d2b567b4c5eaa68ef"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faa2ebf0292c08120492df052b0016313850f54431fb521f3f9e572013429695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff897ff9a7150ee355f0df0b2a4aa903fb672345aed82480a9506d086a14033b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b1499dbfa087f5644434b0f6c99d8f601049a688e255f355a4752edb7e3bf7d"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb35ecb12405b9feefc581f16a57cbf12a300e6a11bcbe3bce9d8f149836808"
    sha256 cellar: :any_skip_relocation, monterey:       "888e2b757c8d003c544f6c43beaf29934de16f2e4c9291eefb9a851e1f14e1da"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f5a4298466d00d40cfddbce067774498a6d25cece617885be97ce579f63f3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb14d7549c4ab22a1ccc177dd4ddca8f536df8ee39150d621a5e42ea38fdd883"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
