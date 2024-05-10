class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "c90d89fc0b9572e8d1d78f2009c99969f875fda75d177cda5f704897ecd1e0e5"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f156872a6576124db2ead13d6c68ac372a61f98df715e75d3e1bf3739b6d3db2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7cf02c3226330ab72d23f31c23817d8dc08745c4e1b41cce337489203907dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2acc5537c6bd099fab5bcf0df3cc58383bb3b77e0150987f151f1a0b9ab483f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "160e51155664f7ccea087ee347d064b773015b89091647ece25fe2c96b6cd6c8"
    sha256 cellar: :any_skip_relocation, ventura:        "ff0711bc27cd6565e7d9340ee95a534edeece68ccf98463b5dcfddc569670a26"
    sha256 cellar: :any_skip_relocation, monterey:       "35f669510da752e8e4eb706b102f635ff8327283b6335f2bde76040cd0ae6800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f99bf2c58740ffe3923d112017862d494c5ed88d92f60291614dc4d4e9abbc97"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
