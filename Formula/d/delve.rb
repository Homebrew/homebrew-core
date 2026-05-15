class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "c5abd02033d7601a41bb6748589c0be42080dc4f91c7e48fc8cbb7f558cc8748"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00bad38c96bd66dcf31f61a4c82ac2ba16618ae85c237ad3a81786fa1b5fb5a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00bad38c96bd66dcf31f61a4c82ac2ba16618ae85c237ad3a81786fa1b5fb5a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bad38c96bd66dcf31f61a4c82ac2ba16618ae85c237ad3a81786fa1b5fb5a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a20442a89c4fadf02572f3000e4a9de41ec03e968c095d966ee2207e41b6ba8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b373bd9580fefa18cbecc54fe620f5f4b958e48d0c7369a548dac603b25f667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09f0c5c34412d71748093a836ca0c87d5edc9f1bc53702dfb91395404343e6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
