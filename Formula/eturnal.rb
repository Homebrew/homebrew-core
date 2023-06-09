class Eturnal < Formula
  desc "STUN/TURN server"
  homepage "https://eturnal.net"
  url "https://eturnal.net/download/eturnal-1.10.1.tar.gz"
  sha256 "a8f999a2a4b84cbe690bc762bb6b6bd67ebc70becb2f68c65b92e15edf132524"
  license "Apache-2.0"
  head "https://github.com/processone/eturnal.git", branch: "master"

  depends_on "erlang" => :build
  depends_on "rebar3" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  conflicts_with "ejabberd", because: "both install e.g. `p1_utils-x.x.x` lib"

  def install
    # Patches
    ## change default install dir, epmd address
    inreplace "build.config" do |s|
      s.gsub! "/opt/#{name}", opt_prefix.to_s
      s.gsub! 'erl_epmd_address, "127.0.0.1"', 'erl_epmd_address, ""'
    end
    ## change default default config dir
    inreplace "config/sys.config" do |s|
      s.gsub! "$ETURNAL_ETC_PREFIX/etc/#{name}.yml", "#{etc}/#{name}.yml"
    end
    ## !!! patch eturnalctl script, !!!
    ## !!! remove before updating to newer version than 1.10.1 !!!
    unless build.head?
      inreplace "scripts/eturnalctl" do |s|
        s.gsub! "(readlink ", "(readlink -f "
      end
    end

    # build release
    system "rebar3", "as", "prod", "release"
    # conduct rebar3 test suites
    system "rebar3", "xref"
    system "rebar3", "eunit"
    system "rebar3", "ct"

    # install libraries & configuration files
    prefix.install "_build/prod/rel/#{name}/bin"
    prefix.install "_build/prod/rel/#{name}/lib"
    prefix.install "_build/prod/rel/#{name}/releases"
    prefix.install Dir["_build/prod/rel/#{name}/erts-*"]

    cd "_build/prod/rel/#{name}/etc" do
      etc.install "#{name}.yml"
      (prefix/"etc").install "systemd"
    end

    # move doc pages
    (share/"doc/#{name}").install "_build/prod/rel/#{name}/doc/LICENSE.txt"
    (share/"doc/#{name}").install "_build/prod/rel/#{name}/doc/README.md"
    (share/"doc/#{name}").install "_build/prod/rel/#{name}/doc/CHANGELOG.md"
  end

  def post_install
    (var/"log/#{name}").mkpath
    (var/"log/#{name}").install_symlink opt_prefix/"log"
    (var/"run/#{name}").mkpath
    (var/"run/#{name}").install_symlink opt_prefix/"run"
    (var/"lib/#{name}").mkpath

    # put a random secure cookie
    # cannot use this with HEAD currently
    unless build.head?
      vm_args_file = opt_prefix/"releases/#{version}/vm.args"
      require "securerandom"
      cookie = SecureRandom.hex
      File.open(vm_args_file.to_s, "a") { |f| f << "-setcookie #{cookie}\n" }
    end
  end

  def caveats
    <<~EOS
      For convenience the erlang cookie is currently randomly hard-coded in
      `$(brew --prefix)/opt/#{name}/releases/#{version}/vm.args`. To harden your
      #{name} you should delete the last line '-setcookie r4nd0mstr1n6' and
      afterwards start your service. Make sure, that all users calling #{name}
      e.g. with $(brew --prefix)/opt/#{name}/bin/#{name}ctl have the same
      `.erlang.cookie` file in their `$HOME` directory. This does currently not
      apply to installations from HEAD.

      With macOS > 12.3 `#{name}ctl` can be invoked directly without specifying
      the path `$(brew --prefix)/opt/#{name}/bin/#{name}ctl`.

      #{name}'s configuration file `$(brew --prefix)/etc/#{name}.yml` uses the
      (indentation-sensitive!) YAML format. A documentation can be found on
      https://#{name}.net or on https://github.com/processone/#{name}.
    EOS
  end

  service do
    run [opt_bin/"eturnalctl", "foreground"]
    environment_variables HOME: var/"lib/eturnal"
    working_dir var/"lib/eturnal"
    # log_path var/"log/eturnal"
    # error_log_path var/"log/eturnal"
    # process_type :background
  end

  test do
    ENV["HOME"] = var/"lib/eturnal"
    ENV["LOGS_DIRECTORY"] = var/"log/eturnal"
    ENV["RUNTIME_DIRECTORY"] = var/"run/eturnal"
    system opt_prefix/"bin/#{name}ctl", "daemon"
    system opt_prefix/"bin/#{name}ctl", "ping"
    system opt_prefix/"bin/#{name}ctl", "info"
    system opt_prefix/"bin/#{name}ctl", "stop"
  end
end
