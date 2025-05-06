class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "fd6df2d28d5a0f1a4cefcaefb1d5a7e73a40e2aed8f15f7276277596fd970f1d"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66e26dbb46e1537ed6ad7ab78b63035a72a3acf7033a3f2138abdaac98e76559"
    sha256 cellar: :any,                 arm64_sonoma:  "ba3ee979c33f9582b2cfc271d9c46a3fe6b100d083a1a20d6815015ff791c43d"
    sha256 cellar: :any,                 arm64_ventura: "625f92819f038c176402410ad52c9fdf79c30bd61d0714b3566b48aca29d4657"
    sha256 cellar: :any,                 sonoma:        "877622e78dc41e19ffa984e2d3e8746daf0a97bb70279746ae631b29952220ef"
    sha256 cellar: :any,                 ventura:       "89fffe2c86bda927cd009a5112535199d52257cac326c653147a58d2931d8b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c12c2044f4cf607be4a8766f6adf9926bafa6ebb4b4d92cda346a3ff94e500c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09df817e9c223875e94b0ead41e10519e4dd66c2d496d303277b16cec96595c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "ailed to find a Rust project in this directory.", output
  end
end
