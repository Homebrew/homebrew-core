class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a1274ad02b74ccab7be9dbe2034cdcc817096ad8067c1d42b639a40c94abf864"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68fcc1e9cfd889ac4e999468edfe4bd0630a08c6cd14c1fb647b09362df8e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c864453f7525c592a7bfe08ce8dc360ed00bc216e8c85c98264a12070715f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f8159c9e73f1079322e552f1befa4d0a50369ac1202e42f6c51650388a42be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2217c738205d2df48b557f20c6bd9215200dab98c63caf6c707033ebd4ef936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1100cb26ad99b07e360377cf70294c19e73cfaf6c8c396ca25d0551b3cb10b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e849ef147830e67fa4a59d2331ca9d88ce6c286ecccc9abd0dead94d6f5b86f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    %w[qq qa].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "Error: Missing API key", shell_output("#{bin}/qq 'test' 2>&1", 1)
  end
end
