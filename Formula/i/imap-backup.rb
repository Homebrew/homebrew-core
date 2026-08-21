class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "b224c2a2a2eefb6438f2da4a9954f7ae6d7b876b718f15629824b76e4e021e4d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "eeb2993395021dd3dc8abca2d48bbddb22efecc566a0c98c8f5e50aba6441dbb"
    sha256 cellar: :any, arm64_sequoia: "5c81870ce3000963a29288356aebf47821988358b48ff07b699a69ce8f9df024"
    sha256 cellar: :any, arm64_sonoma:  "bb035cb6cbbbb8b17ddd91e0cceeab0d569f48e16f8137f8830418ebb2a88462"
    sha256 cellar: :any, sonoma:        "292b3e89ce196bde931d1e16a59d0a5b9579c209a49f025adfea5a0b8ce87dfd"
    sha256 cellar: :any, arm64_linux:   "53861e42f54687326b390bc7586b09bf5e62bcbd333002dbc5e592fc7e9acd04"
    sha256 cellar: :any, x86_64_linux:  "15ea28841f0f614833396b3a68a7dc0a8453dc83c853b54b2eac477bed70662a"
  end

  depends_on "ruby"

  uses_from_macos "libffi"

  # List with `gem install --explain imap-backup --platform ruby -v #{version}`
  resource "os" do
    url "https://rubygems.org/gems/os-1.1.4.gem"
    sha256 "57816d6a334e7bd6aed048f4b0308226c5fb027433b67d90a9ab435f35108d3f"
  end

  resource "racc" do
    url "https://rubygems.org/gems/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "mork-parser" do
    url "https://rubygems.org/gems/mork-parser-0.2.0.gem"
    sha256 "34afa19b494aeca92cbe4fc4d2357246b380e936684ba7a301f65abd5a480622"
  end

  resource "thunderbird" do
    url "https://rubygems.org/gems/thunderbird-0.6.0.gem"
    sha256 "19aa889b396093c5ec0687fb21f7e9a6ca8c11833f39885c50c5bf7e6fceae3b"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.5.0.gem"
    sha256 "e3a9e55fe857e44859ce104a84675ab6e8cd59c650a49106a05f55f136425e73"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.17.4.gem"
    sha256 "bcd1642e06f0d16fc9e09ac6d49c3a7298b9789bcb58127302f934e437d60acf"
  end

  resource "sys-proctable" do
    url "https://rubygems.org/gems/sys-proctable-1.3.0.gem"
    sha256 "31f61ad79aa0d4412155132beadf2b7ca706a6badce4ad2dfeda5d1ca4916e54"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-13.3.1.gem"
    sha256 "8c9e89d09f66a26a01264e7e3480ec0607f0c497a861ef16063604b1b08eb19c"
  end

  resource "ostruct" do
    url "https://rubygems.org/gems/ostruct-0.6.3.gem"
    sha256 "95a2ed4a4bd1d190784e666b47b2d3f078e4a9efda2fccf18f84ddc6538ed912"
  end

  resource "timeout" do
    url "https://rubygems.org/gems/timeout-0.6.0.gem"
    sha256 "6d722ad619f96ee383a0c557ec6eb8c4ecb08af3af62098a0be5057bf00de1af"
  end

  resource "net-protocol" do
    url "https://rubygems.org/gems/net-protocol-0.2.2.gem"
    sha256 "aa73e0cba6a125369de9837b8d8ef82a61849360eba0521900e2c3713aa162a8"
  end

  resource "net-smtp" do
    url "https://rubygems.org/gems/net-smtp-0.5.1.gem"
    sha256 "ed96a0af63c524fceb4b29b0d352195c30d82dd916a42f03c62a3a70e5b70736"
  end

  resource "date" do
    url "https://rubygems.org/gems/date-3.5.1.gem"
    sha256 "750d06384d7b9c15d562c76291407d89e368dda4d4fff957eb94962d325a0dc0"
  end

  resource "net-imap" do
    url "https://rubygems.org/gems/net-imap-0.6.2.gem"
    sha256 "08caacad486853c61676cca0c0c47df93db02abc4a8239a8b67eb0981428acc6"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "mail" do
    url "https://rubygems.org/gems/mail-2.7.1.gem"
    sha256 "ec2a3d489f7510b90d8eaa3f6abaad7038cf1d663cdf8ee66d0214a0bdf99c03"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "fiddle" do
    url "https://rubygems.org/gems/fiddle-1.1.8.gem"
    sha256 "7fa8ee3627271497f3add5503acdbc3f40b32f610fc1cf49634f083ef3f32eee"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.5.gem"
    sha256 "1c6803e8aa6bdb2c29e91945d095050601bf6d58474993575adf6f3b89b32ef4"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.3.6.gem"
    sha256 "6b56837e1e7e5292f9864f34b69c5a2cbc75c0cf5338f1ce9903d10fa762d5ab"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.14.8.gem"
    sha256 "285778639134865c5e0f6269e0b818256017e8cde89993fdfcbfb64d088824a5"
  end

  resource "io-console" do
    url "https://rubygems.org/gems/io-console-0.8.2.gem"
    sha256 "d6e3ae7a7cc7574f4b8893b4fca2162e57a825b223a177b7afa236c5ef9814cc"
  end

  resource "reline" do
    url "https://rubygems.org/gems/reline-0.6.3.gem"
    sha256 "1198b04973565b36ec0f11542ab3f5cfeeec34823f4e54cebde90968092b1835"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-3.1.2.gem"
    sha256 "67cbd34d19f6ef11a7ee1d82ffab5d36dfd5b3be861f450fc1716c7125f4bb4a"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm libexec.glob("extensions/*/*/*/mkmf.log")
  end

  test do
    assert_match "Choose an action:", pipe_output("#{bin}/imap-backup setup", "4\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end
