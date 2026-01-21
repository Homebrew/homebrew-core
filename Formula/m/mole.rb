class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.22.1.tar.gz"
  sha256 "ba7c2ab8af2d99dc00e6e91eaaa64f860d997f072625e7440bfba2099a1ddf54"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c2aa4617e525d2d9e44b844c563bdb972e0426d5173f6c8eafb9bcf93375930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f799e48b66b84cf83ebc4fc2c531a9cae6b3d9db7d139e43577b79ec493412c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc643e1f74896fbe8f75ca669baf58cdd025dc533b62a7aa9c436bf0b4f2c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af4f8543cfa2fc779ecfbd90998712d2eba752be376cd578093aef4e25403bc"
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
