class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.37.0.tar.gz"
  sha256 "240c8e1791b7f1472621efb090a78ab4bf435ec6046dae9b1fae15991a11588e"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2628157bfe35c40bee8d4c11223548b88f65a3a3a3bcc718334bb9bc34b8d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5458e0b4af91622e3fc648867a78442727d638f6579cfdf0d9bd27cc807c16ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e29c8492538f3cf6c7eed3ebf81a553ab471a31e531c8a7b6c0bce9910cbb80"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef534b9a91998bf62c84399d2257187c291d094c3ec3079b236d68529599b401"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"

    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
