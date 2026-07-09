class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2c8bb5f1e1905d7677c892092ba37c21fd728163fba91bf8177a2a20ceb56227"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c0aa3e0a670eeb8e64aff66e301e36e0e9a30d8242a1671e6987fe589360ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c53e8a84b7d0921e10aa8cd9a34b4ce19cd23c4621549ae96259b898d0dda4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b4fb49ca862b5b2dc4f13ab1e50a429083facf740f58f076c4cd281287a2409"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1df7f4a669e28002b2d680b43291ea401d9022fcfeff5d7f0a986d219f64a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09220ed851c4d6699aacb8516de30217e074471a4c010030cb07270c2d6b498"
    sha256 cellar: :any,                 x86_64_linux:  "f05ddb55528732f219e9d23f88484d6ad4edf7c8cabed9ca95f66947a76efa48"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"

    generate_completions_from_executable(bin/"prestd", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"prest.toml").write <<~TOML
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    TOML

    output = shell_output("#{bin}/prestd migrate up --path .", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
