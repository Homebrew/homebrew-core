class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "676cd6bd039c25fe649a35ea86977706c0818442624da87c7f4285257cc7aa12"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e6c058d9f541092451cca81e074ba818289b762e5a6c48017c7d745abe0310c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d108282c96e19011ef57d18b0515746bc9d8207cbc6dc6e4bed2abfed460be72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16dab82815f8d00fc1a42710e183f428c8b5cf84d224890bfcfd6f292a8b426"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e91289591a8fc30fae2288c79fc25ff14c586c3a169f58c88f2a8a1f654b666"
    sha256 cellar: :any_skip_relocation, sonoma:        "82cf37a21c4ad4a910d301b99bc05a530930f20c6ffc3e196ea87c889ffe006c"
    sha256 cellar: :any_skip_relocation, ventura:       "44d411588250325cada66a9611f59bcc8111776b919d3594cc8b9edc7d85b3dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4b81f0d5228c0d992daa2b63fd37df025e805af6fa8a9b6affcfc89bc35dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e0dd1772ebbb419eb4dad3f418b48a83b2e3be7c1539c3f242e2d582fa3802"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
