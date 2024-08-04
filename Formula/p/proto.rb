class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.39.7.tar.gz"
  sha256 "fb7334967aaa735788dfa5caae3b01326c0f7a8f3754f92fb4f4b7197ff89ec7"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b322246e48604f87f93cb2e1cdc59c7855ee567bc7b7ccb489ed21090efe66a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f744f0c4c29f01ea2c8378ce0699eed532c20ffd2170c24cee8baf96d074b0ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c00a354de04601a7e4d9396ff717d42307d7e6d05249729c9ca53ccd8be8860"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d611c6e944161cca9cac741202e831eb50994f4dd8d8e256b9177eaffd39bb7"
    sha256 cellar: :any_skip_relocation, ventura:        "158207581cb3d2794adda2615e92f728949cf9fe04a46e82f8c82bce03707a74"
    sha256 cellar: :any_skip_relocation, monterey:       "89a9d7c8e468d3a18546bfd99b9b850632e5bed8944c6c3abbb9e188305a8e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac8a73349c26713d7f6f4eccff746d8b81fd2014c56d4218a94bad2616290ce"
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
