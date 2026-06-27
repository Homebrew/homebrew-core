class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.44.0.tar.gz"
  sha256 "a3934d8cff7b292c173eb949dee094a464d924f9d69ede678975dbb8145c8fbe"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec19f657cd2e96ba257b8d4c30868484d024761e51868e330ac97850cc57df3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d66e1c0303a7aeddf251cf6d9104c819f65f5d53899bbd84c3a151118986c38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80419b68d56b88c712b31d7aa09f99bec017e1e2de5ef49a96300d3d955d5048"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf2173136e5f7d48f24049b1d41784672a78c43cc68959ccc472c63b9ec20a69"
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
