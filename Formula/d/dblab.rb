class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "cbf6bd96fabc7fdc13252f081df2f7079ed6c3445202ad5e522da664465a3c2e"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a845bf38ce6258049a8467616c70f7d546957cb1a5a1394932d6ee9a91a26d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5265c1ec46dd9d3a75c236cded07db33090f3c70966f638c466a1615859f6ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d9de27d16be53abd3426e2f01b1679901ac1a9571cdb817405043e251d4348"
    sha256 cellar: :any_skip_relocation, sonoma:        "594b014cba2c0ee31fc685955158f4e2eebec578b108754b18e9e516d0a6b9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f4ce8f8de2c33a125accab4485c1124c379bd47d86e38ae6894c90003d7b0b"
    sha256 cellar: :any,                 x86_64_linux:  "88f5e014fa1605f4e876f4ac9c9306d70031d011873fdb67fd250bea2049608e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
