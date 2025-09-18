class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09031e60548f34f05e07faeb0e26b002aeb655488d152dd811021fba8d850162"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e0ddafd03ceedaf46157074627f10b5bc2ae1095803c7da7ff4259f8972c2c7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "676022be294ea2d4654c968012a952dac36f61e573e44f3fd99b52f071767372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b325f6945c083382956ed3f81d453e17151a0a09f4eff7d5f84c7208d1a1cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a05553e529ee3f7d2a212033b5353e1bae2534a7651e0b4ac4ac66c2301c6f96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05553e529ee3f7d2a212033b5353e1bae2534a7651e0b4ac4ac66c2301c6f96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97031cd42ff2a4338b973493629d314f1ad1e7a79ca7e912503f68585f5bfc61"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b325f6945c083382956ed3f81d453e17151a0a09f4eff7d5f84c7208d1a1cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "a05553e529ee3f7d2a212033b5353e1bae2534a7651e0b4ac4ac66c2301c6f96"
    sha256 cellar: :any_skip_relocation, monterey:       "a05553e529ee3f7d2a212033b5353e1bae2534a7651e0b4ac4ac66c2301c6f96"
    sha256 cellar: :any_skip_relocation, big_sur:        "97031cd42ff2a4338b973493629d314f1ad1e7a79ca7e912503f68585f5bfc61"
    sha256 cellar: :any_skip_relocation, catalina:       "97031cd42ff2a4338b973493629d314f1ad1e7a79ca7e912503f68585f5bfc61"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "98197a6b45c3c46674268c2033a0648ce4afe2c89904a56f959d1c37a2f2a902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584a4e42785d258568915c287d02ea037c685bd577812c66844350425fea5df3"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "imessage.gemspec", "-o", "imessage-#{version}.gem"
    system "gem", "install", "--local", "--verbose", "imessage-#{version}.gem", "--no-document"

    bin.install libexec/"bin/imessage"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "imessage v#{version}", shell_output("#{bin}/imessage --version")
  end
end
