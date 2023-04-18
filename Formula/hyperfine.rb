class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.16.1.tar.gz"
  sha256 "ffb3298945cbe2c068ca1a074946d55b9add83c9df720eda2ed7f3d94d7e65d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4e64bbc834bbd95693893999e6c35a5bb6969cbeae3546c49b9f529dbfae02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0bcdddf7842693ae990fc3eb86aff4ceba2af89384e42955493df395fe91f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd00a8876e57807b5f49effaadd67cccaaf50b7448711ef2241686dbf2851b45"
    sha256 cellar: :any_skip_relocation, ventura:        "e14e672beb3f0e3d1ca36bb3a9c6031b0fbaa556198b721319a826c26e314b28"
    sha256 cellar: :any_skip_relocation, monterey:       "129cfb0dc06d2eb4f578161057803e7c3d43ed766a2fe3b2c1ef335d2fdd03c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b40fc1aa7e9e652b7553289845f2581b627e92bb4ae3bb2bcc1088cded48a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230b38f81f89342f97006f8d4301c39176ee9780d80d8a59a0be8b1d88704254"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
