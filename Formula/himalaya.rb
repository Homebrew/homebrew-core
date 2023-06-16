class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org/himalaya/"
  url "https://github.com/soywod/himalaya/archive/v0.8.1.tar.gz"
  sha256 "0a4d6325f541e0eb1b23c2f9b6b47eb01feaf78a0eb3fd5a29624990d9ca0e23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a554dd030c86ee0ebf3b1691bea099642fb5a3146e1adcaa936cc4a7dced061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4db629ab1c3aab236cc8bfe4dee9c745da810831c4a56cafaf515ba81e19c38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c13c09ee27a53541f721452a193e3462a5832934a1a58c2d274a5626bea5f38a"
    sha256 cellar: :any_skip_relocation, ventura:        "11882cef069954fc34067d97c65e7a874d6bb6fa7777f44a39eabf9dc6805b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "0f3cdecbecdf094929be4f841d5606a82374d93292049e20b39a3ddd0010c9d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8aef6816fbf42e4983155e406484cfff96d4ee1a393b1bfae863deab78747c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59dfbbbc9002fd9b47889a08b1b26e10685dac4163e8b2dea003f32be729fcb8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/soywod/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~EOS
      name = "Your full name"
      downloads-dir = "/abs/path/to/downloads"
      signature = """
      --
      Regards,
      """

      [gmail]
      default = true
      email = "your.email@gmail.com"

      backend = "imap"
      imap-host = "imap.gmail.com"
      imap-port = 993
      imap-login = "your.email@gmail.com"
      imap-auth  = "passwd"
      imap-passwd = { cmd = "echo password" }

      sender = "smtp"
      smtp-host = "smtp.gmail.com"
      smtp-port = 465
      smtp-login = "your.email@gmail.com"
      smtp-auth  = "passwd"
      smtp-passwd = { cmd = "echo password" }
    EOS

    assert_match "Error: cannot login to imap server", shell_output(bin/"himalaya 2>&1", 1)
  end
end
