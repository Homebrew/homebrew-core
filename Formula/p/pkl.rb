class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.31.0.tar.gz"
  sha256 "7458b06d980cb49f79ec94df44b32bec916d5832d1680daa71d9fcad5300e7f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6324d87a932f1bc3ec822ff89ca53c346968e5994930e05d722ff582d2985e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "980a5862e2410cb852fd39711a245c4e2a03c781a5e60b403e5ddfb9b52f79b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc352763d24be5d455aa9b13ef19e7e03a880c95512394c8eb8a7363f8a3bfb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a068b34a1e823a08b6bc048e1d6b515b1fba2d5c18efff4fdc9b1bbcedeb030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5835a5af985c643d0f8ce240220c304b45949b6e8dcf1f74407252b3e2a98bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f21e45e485932e7878ec7ff1b15db4c37de9a4b2531480757631b23bbe5901d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "pkl-cli:#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
    generate_completions_from_executable(bin/"pkl", "shell-completion")
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
