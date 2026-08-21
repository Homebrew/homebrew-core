class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.7.tar.gz"
  sha256 "c6782a28842b1c0478524ac06a4f2ede784038ee298d6e2162c0b089c4306a3c"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47cbe5d3682aa908585ff94278921a65deaeeda9e756704a4c1edc769b5a287f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ca239fc5c01bacec5a17b8e3e8e90c06535afd5295752f3c74ef0c89058057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1d5162a65c3b5dd6a130a106cbb2e39e71171d4e4a6dc4669ab6178f37e952"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ea5fc1c0ae2eceb806c28b380b4f4481ea85d020b63125d3385207032c4620"
    sha256 cellar: :any,                 arm64_linux:   "95fdb3c4514bc2f7d352f323a4d20c8befd7c3794c41accb148d0379afb834bd"
    sha256 cellar: :any,                 x86_64_linux:  "f7b6cb77ad29adf5a7463fc83e5e984a362aba096095b237a72472740a165ed8"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end
