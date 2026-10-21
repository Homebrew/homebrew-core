class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "97f5fe6d609ac9445da305e518e6f37dbaa45c657304ade227f147f5f47712a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29c75eb5ecbc15f5c358dffdd89fe9e7fa9ca6cbee3a158a1c2263467a6f6c54"
    sha256 cellar: :any, arm64_tahoe:       "7ec0139e985c19a0c1013120b92121f320841143bf1e94dac9e694ca39a104b6"
    sha256 cellar: :any, arm64_sequoia:     "a4b28b0ec29b60e0283472471e916eac34554d4b3c79bbea778c3f004fdb11c3"
    sha256 cellar: :any, arm64_linux:       "9e4feb56a501e76a1a8b8426be0de93d58c87cbbed4991800b89d6c3abde2ba9"
    sha256 cellar: :any, x86_64_linux:      "3a9a4a1d41cd16386643547ea0fc362ef84af1b004890abcbfbaff48ba95f6bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "vectorscan" => :build # kingfisher-vectorscan uses static library
  depends_on "aws-lc"

  uses_from_macos "sqlite"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1"
    ENV["HYPERSCAN_ROOT"] = formula_opt_prefix("vectorscan")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    args = ["--features=system-alloc"] if OS.mac?
    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
