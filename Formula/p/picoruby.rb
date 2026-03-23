class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby/archive/refs/tags/3.0.2.tar.gz"
  sha256 "33b951be8969570726bc34632fa5e0f332ee6e8ed782b5ec0f8fd5629a6be959"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419ef195703d3c19a2bebaaa66bfc1d729a832a64a10a3e0a97b93a84eff074c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "334066fe3a708a799b2495b24962c1f96aad0272822a210120522a489b8c6091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429d0c5f79cd22ef4ac5ed870a5a19756b3c090a94f808ed9ac41bb55c1b8a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c96d98fbf69ef676359fa3f6362702420c537cd555031781a8fbe59097810e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf94a61a1dd5b6fb4f251c3a82301e8903815066572560d90e308bc7a8e84a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd416f436c2843b824f346ae05d591ce6e5ad02ed00948c23f1f66f3e1f4029b"
  end

  uses_from_macos "ruby" => :build

  def install
    ENV["MRUBY_CONFIG"] = buildpath/"build_config/default.rb"
    system "rake"
    bin.install Dir["build/host/bin/*"]
    lib.install Dir["build/host/lib/*"]
    include.install Dir["include/*"]
  end

  test do
    output = shell_output("#{bin}/picoruby -e \"puts 'Hello, PicoRuby!'\"")
    assert_match "Hello, PicoRuby!", output
  end
end
