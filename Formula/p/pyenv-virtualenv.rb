class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c60fe08d8d0d5c3ae0eba224081214ce831135d62d75e1d607206411621427d7"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2ee67c170e30b4a2fe9106678839f14f526c92206a0027f882adcff6068dd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fb9fb141148ea0e5463249d2a0d79beda9539fa0b30d0171d28a751c06d1a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49fb9fb141148ea0e5463249d2a0d79beda9539fa0b30d0171d28a751c06d1a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49fb9fb141148ea0e5463249d2a0d79beda9539fa0b30d0171d28a751c06d1a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "44b1920d7c18775626d12d6883c65fb789462b0a2fbdba2588132248aa6277d8"
    sha256 cellar: :any_skip_relocation, ventura:        "577ddf85d837acd6accf6aebf29be59dcd0ce17a23c57b25de07b564214f6203"
    sha256 cellar: :any_skip_relocation, monterey:       "577ddf85d837acd6accf6aebf29be59dcd0ce17a23c57b25de07b564214f6203"
    sha256 cellar: :any_skip_relocation, big_sur:        "577ddf85d837acd6accf6aebf29be59dcd0ce17a23c57b25de07b564214f6203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd41573b474f1991731daff3bef3aa2c4b72dca46129864e601db9f53787fdb6"
  end

  depends_on "pyenv"

  on_macos do
    # `readlink` on macOS Big Sur and earlier doesn't support the `-f` option
    depends_on "coreutils"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"

    # macOS Big Sur and earlier do not support `readlink -f`
    inreplace bin/"pyenv-virtualenv-prefix", "readlink", "#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
