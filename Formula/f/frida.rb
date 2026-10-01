class Frida < Formula
  desc "Dynamic instrumentation toolkit for developers and reverse-engineers"
  homepage "https://frida.re/"
  url "https://github.com/frida/frida/archive/refs/tags/17.19.0.tar.gz"
  sha256 "ec82b4d5fdd7c899f4906a4924dcc28d0568477b7833c8e2d620f166b9c050a4"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "perl" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "vala" => :build
  depends_on "brotli"
  depends_on "capstone"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libgee"
  depends_on "libnghttp2"
  depends_on "libnice"
  depends_on "libsoup"
  depends_on "lzfse"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libbpf"
    depends_on "libunwind"
    depends_on "systemd"
  end

  resource "frida-releng" do
    url "https://github.com/frida/releng/archive/1089fe24c221811f0089ec7c1c16a6b1602cf079.tar.gz"
    sha256 "e84c9dd62e55793e554abc47a10718d3423e8dabc9409e53066384dec33f1cea"
  end

  resource "frida-meson" do
    url "https://github.com/frida/meson/archive/342713453ed2f10c99fbbe6f7625170e04c12c8f.tar.gz"
    sha256 "1eb587761d164b18c459b14adb8f5aeb9885911010cf0d0991627d14051614d1"
  end

  resource "frida-tomlkit" do
    url "https://github.com/python-poetry/tomlkit/archive/911cccd630965ff423316e25b4685ecf7df0ec0a.tar.gz"
    sha256 "2f9e579cb4f88c4425554e74451e0cedefe39b3f8e9fc04407f196c62a8eff74"
  end

  resource "frida-core" do
    url "https://github.com/frida/frida-core/archive/b66a485f7c8f12407c51d5994907eca549d27066.tar.gz"
    sha256 "4e436a8ba035eba7c12d2caaa723e45bda488a95a22f953b7f1d7480b61889a7"
  end

  resource "frida-gum" do
    url "https://github.com/frida/frida-gum/archive/02bc3d805455f79eef1de1acbbfe72328d477756.tar.gz"
    sha256 "909ed0dac7a59dd70b0751eed57dd0b4b7197accd230e23a4a76e3aa4db97193"
  end

  resource "frida-capstone" do
    on_macos do
      url "https://github.com/frida/capstone/archive/d536b1577fd033a31d75f48fd183aa425256cc18.tar.gz"
      sha256 "56b4910b0ddfbd954e281db3e652f91162265c939f69a2370964ad14a6ffc0d2"
    end
  end

  resource "frida-glib" do
    url "https://github.com/frida/glib/archive/e0cc7c6f0d88f47e4dee4607df085d08c89b8a6a.tar.gz"
    sha256 "71bca7ca1106ec879aa33c087fa84d330e6f9d88ec7376253348f03de6497990"
  end

  resource "frida-pcre2" do
    url "https://github.com/frida/pcre2/archive/b47486922fdc3486499b310dc9cf903449700474.tar.gz"
    sha256 "6dfae668d6e887a552358270cd215bfa13ab3864a4304f7cd7026474c48d36c5"
  end

  resource "frida-libffi" do
    url "https://github.com/frida/libffi/archive/3fe3257235cc9ffd192e1cd567f1bdfff751fa3e.tar.gz"
    sha256 "6a8c2fee461bc7562f2beb5635e7903f01623f404bf48d9edd6b8773f0baef75"
  end

  resource "frida-zlib" do
    url "https://github.com/frida/zlib/archive/171a3eacaea8b731ef1fc586e7777b77742e2a1d.tar.gz"
    sha256 "3d9fec0b58e66e0733c6276edd2ea52f7a1c12ead56b2be78506ccaffc2d9fa2"
  end

  resource "frida-gvdb" do
    url "https://gitlab.gnome.org/GNOME/gvdb/-/archive/0854af0fdb6d527a8d1999835ac2c5059976c210/gvdb-0854af0fdb6d527a8d1999835ac2c5059976c210.tar.gz"
    sha256 "08352e54e8216d9001820c627c62858585465b51dc557cc22f0f4770ed182ebd"
  end

  resource "frida-glib-networking" do
    url "https://github.com/frida/glib-networking/archive/ef47b1a09cf8c1875f181bcf901643689a56d12f.tar.gz"
    sha256 "87a6c4a244094eadcc1f2e18b3800ffa231c215124b7af113c5eb0d056028d32"
  end

  resource "frida-libgee" do
    url "https://github.com/frida/libgee/archive/ad17ed847039469fcc2dc711ecfee2bbf7d2bf87.tar.gz"
    sha256 "59817deaa4db678727a3150cbdc14adebff78fa7011b42f7af7574e64598bfb5"
  end

  resource "frida-json-glib" do
    url "https://github.com/frida/json-glib/archive/1a39cbe151b02c4192987c8fcc98997a59db2154.tar.gz"
    sha256 "da733d01080eca5f985cda182017e94bbe8ffaed4bc3b17cd08f6abcf79d534b"
  end

  resource "frida-libnice" do
    url "https://github.com/frida/libnice/archive/9a3da6e3e5bbcf935fd85b6b8557ff8c7dd9032c.tar.gz"
    sha256 "cf5d350e68a18f9b93edceb37cec49d34561682bf969e6d2dc08faa80d2ccb80"
  end

  resource "frida-libsoup" do
    url "https://github.com/frida/libsoup/archive/4fd67869310b9de8fe2947bc8504ccbcf1abf285.tar.gz"
    sha256 "49ee3f99ba8e05ecf82ffe1345b5d2e07a4624f2d3e07a96251a579a015595e4"
  end

  resource "frida-python" do
    url "https://github.com/frida/frida-python/archive/9947655e6a30f0f929f5101e1a049291b4f0787a.tar.gz"
    sha256 "b5d27b42bfa04f78ae90cabf8288522d2ae709f34cae8e296ba042baf83b626a"
  end

  resource "frida-bindgen" do
    url "https://github.com/frida/frida-bindgen/archive/eace04901ef6300429e8c343095297df042dba0e.tar.gz"
    sha256 "95cb4f597d0b3fa4fb957e37ad9fa21ce143ec30644754b1c6a5ba3d81f76279"
  end

  resource "frida-tinycc" do
    url "https://github.com/frida/tinycc/archive/3da7432bebd348bf16cdc7a22c3717b4f22946af.tar.gz"
    sha256 "c38d889d9a2907d96157c5483c9231b1cb2d917e15a72b4843b1f348024ebfab"
  end

  resource "frida-vala" do
    url "https://github.com/frida/vala/archive/172348fa9123ff4a95d541c5f9e56837434c4b6e.tar.gz"
    sha256 "008057c29f5504ebd3d5d46f889d62625a57935e982a69c0d886bc8a759d7b7e"
  end

  resource "frida-libdwarf" do
    url "https://github.com/frida/libdwarf/archive/61ff154ae803d2b0202dbc1bf385cda1ac3ece54.tar.gz"
    sha256 "32dfc6096c5bac4bbaa3d53a8d6bbe1761fed0547fbaff343a3fd7fa61cdb052"
  end

  resource "frida-quickjs" do
    url "https://github.com/frida/quickjs/archive/5925b4859d6ada980c6f6df5833ce30c6d7ea2e0.tar.gz"
    sha256 "326926e6c73ae2934535e5f18dd50252875ef7f94a83826e7cb33f3d8f1f5a49"
  end

  resource "frida-ngtcp2" do
    url "https://github.com/frida/ngtcp2/archive/5b21d4418ff668d9b5ddc4f744b7a28af4196abf.tar.gz"
    sha256 "018f4842eb8d0ca1e369f2a1bf1051324d17ddf972b58e7931733c0c72ff3bce"
  end

  resource "frida-nghttp2" do
    on_macos do
      url "https://github.com/frida/nghttp2/archive/ae13d24ea59c30e36ca53d1b22c4e664588d0445.tar.gz"
      sha256 "207362cb9d439bb325ba9eda2eca75ab95b559f4b94d8e8f1a293183c6326c0d"
    end
  end

  resource "frida-openssl" do
    url "https://github.com/frida/openssl/archive/fa60a1c8c704e4ca0cc0dcb289c3be1fea1b50ff.tar.gz"
    sha256 "53559857d58383256efe59ca7cb55caa0a6635c9680a3c8a5d29fec78f20be71"
  end

  resource "frida-libusb" do
    url "https://github.com/frida/libusb/archive/ffff4bdfe8faa38cecfad5aab106cae923502d55.tar.gz"
    sha256 "0ef44b0ff83d42f35ffbf5ad9066222cc65725741ee787fc96b17b65b217c7d0"
  end

  resource "frida-lwip" do
    url "https://github.com/frida/lwip/archive/00ea2b4c3c57dae81ec3a88c3d58ef38ab17e0c9.tar.gz"
    sha256 "5156a3a0cdce47bd5dbcac1d80f7b3e70ce5c3e430a58c09b640ae7815bef5a4"
  end

  resource "frida-usrsctp" do
    url "https://github.com/frida/usrsctp/archive/57b8b42abad9b00861f92281f013830bbbd0b5f0.tar.gz"
    sha256 "ed368a0273235c58ff497952d33148b72b58405ea8cd1db8ba3f0b5e3d78bf8e"
  end

  allow_network_access! :build

  def install
    ENV["MACOS_CERTID"] ||= "-" if OS.mac?

    {
      "frida-releng" => buildpath/"releng",
      "frida-core"   => buildpath/"subprojects/frida-core",
      "frida-gum"    => buildpath/"subprojects/frida-gum",
      "frida-python" => buildpath/"subprojects/frida-python",
    }.each do |resource_name, destination|
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    inreplace buildpath/"subprojects/frida-core/meson.options",
      "option('helper_modern',",
      <<~MESON
        option('compat_force_fallback_for',
          type: 'string',
          value: '',
          description: 'Dependencies to force to subprojects in compatibility builds',
        )

        option('helper_modern',
      MESON
    inreplace buildpath/"subprojects/frida-core/compat/build.py",
      'forwarded_options += ["-Ddefault_library=static"]',
      <<~PY
        forwarded_options += ["-Ddefault_library=static"]
                        compat_force_fallback_for = next(
                                (o.split("=", 1)[1] for o in options if o.startswith("-Dcompat_force_fallback_for=")), "")
                        if compat_force_fallback_for:
                            forwarded_options += [f"-Dforce_fallback_for={compat_force_fallback_for}"]
      PY
    inreplace buildpath/"subprojects/frida-core/compat/build.py",
      "STRIPPED_COMPAT_OPTIONS = {",
      "STRIPPED_COMPAT_OPTIONS = {\n    \"compat_force_fallback_for\","
    inreplace buildpath/"releng/env.py",
      "    pkg_config_libdir = None",
      <<-PY
    if machine.is_apple and machine != build_machine and sdk_prefix is not None and pkg_config is None:
        pkg_config_binary = find_usable_system_pkg_config()
        if pkg_config_binary is not None:
            pkg_config = [str(pkg_config_binary), f"--define-variable=frida_sdk_prefix={sdk_prefix}"]

    pkg_config_libdir = None
      PY

    {
      "frida-glib" => "glib",
    }.each do |resource_name, subproject|
      destination = buildpath/"subprojects/frida-core/subprojects"/subproject
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    {
      "frida-pcre2"  => "pcre2",
      "frida-libffi" => "libffi",
      "frida-zlib"   => "zlib",
      "frida-gvdb"   => "gvdb",
    }.each do |resource_name, subproject|
      destination = buildpath/"subprojects/frida-core/subprojects/glib/subprojects"/subproject
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    {
      "frida-libgee"    => "libgee",
      "frida-json-glib" => "json-glib",
      "frida-libnice"   => "libnice",
      "frida-libsoup"   => "libsoup",
    }.each do |resource_name, subproject|
      destination = buildpath/"subprojects/frida-core/subprojects"/subproject
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    if OS.mac?
      capstone = buildpath/"subprojects/frida-gum/subprojects/capstone"
      capstone.mkpath
      resource("frida-capstone").stage do
        cp_r Dir["{*,.[!.]*}"], capstone
      end

      nghttp2 = buildpath/"subprojects/frida-gum/subprojects/libsoup/subprojects/nghttp2"
      nghttp2.mkpath
      resource("frida-nghttp2").stage do
        cp_r Dir["{*,.[!.]*}"], nghttp2
      end
    end

    gum_networking = buildpath/"subprojects/frida-gum/subprojects/glib-networking"
    gum_networking.mkpath
    resource("frida-glib-networking").stage do
      cp_r Dir["{*,.[!.]*}"], gum_networking
    end

    {
      "frida-tinycc"   => "tinycc",
      "frida-libdwarf" => "libdwarf",
      "frida-quickjs"  => "quickjs",
    }.each do |resource_name, subproject|
      destination = buildpath/"subprojects/frida-gum/subprojects"/subproject
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    {
      "frida-ngtcp2"  => "ngtcp2",
      "frida-libusb"  => "libusb",
      "frida-lwip"    => "lwip",
      "frida-usrsctp" => "usrsctp",
    }.each do |resource_name, subproject|
      destination = buildpath/"subprojects/frida-core/subprojects"/subproject
      destination.mkpath
      resource(resource_name).stage do
        cp_r Dir["{*,.[!.]*}"], destination
      end
    end

    (buildpath/"subprojects/frida-python/frida-bindgen").mkpath
    resource("frida-bindgen").stage do
      cp_r Dir["{*,.[!.]*}"], buildpath/"subprojects/frida-python/frida-bindgen"
    end

    (buildpath/"releng/meson").mkpath
    resource("frida-meson").stage do
      cp_r Dir["{*,.[!.]*}"], buildpath/"releng/meson"
    end
    (buildpath/"releng/tomlkit").mkpath
    resource("frida-tomlkit").stage do
      cp_r Dir["{*,.[!.]*}"], buildpath/"releng/tomlkit"
    end

    # Build Frida's OpenSSL fork from source; QUIC support is required by Core.
    resource("frida-openssl").stage do
      system "./Configure", "--prefix=#{libexec}", "no-shared", "no-tests"
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install_sw"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib64/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # Build Frida's Vala fork from source; upstream Vala lacks required features.
    resource("frida-vala").stage do
      system "meson", "setup", "build", "--prefix=#{libexec}"
      system "ninja", "-C", "build"
      system "ninja", "-C", "build", "install"
    end
    ENV.prepend_path "PATH", libexec/"bin"
    if OS.mac?
      ENV.prepend_path "DYLD_LIBRARY_PATH", libexec/"lib/vala-0.58"
      ENV.prepend_path "DYLD_LIBRARY_PATH", libexec/"lib64/vala-0.58"
      ENV.prepend_path "DYLD_LIBRARY_PATH", libexec/"lib64"
      ENV.prepend_path "DYLD_LIBRARY_PATH", libexec/"lib"
    else
      ENV.prepend_path "LD_LIBRARY_PATH", libexec/"lib/vala-0.58"
      ENV.prepend_path "LD_LIBRARY_PATH", libexec/"lib64/vala-0.58"
      ENV.prepend_path "LD_LIBRARY_PATH", libexec/"lib64"
      ENV.prepend_path "LD_LIBRARY_PATH", libexec/"lib"
    end
    system "valac", "--version"

    frida_deps = buildpath/"frida-deps"
    host_os = OS.mac? ? "macos" : "linux"
    host_arch = Hardware::CPU.arch.to_s
    toolchain = frida_deps/"toolchain-#{host_os}-#{host_arch}"
    toolchain.mkpath
    %w[bin lib lib64 share].each do |subdir|
      cp_r libexec/subdir, toolchain if (libexec/subdir).directory?
    end
    deps_version = (buildpath/"releng/deps.toml").read[/^version = "([^"]+)"/, 1]
    (toolchain/"VERSION.txt").write("#{deps_version}\n")

    sdk = frida_deps/"sdk-#{host_os}-#{host_arch}"
    sdk_pkgconfig = sdk/"lib/pkgconfig"
    sdk_pkgconfig.mkpath
    pkgconfig_files = Dir.glob((HOMEBREW_PREFIX/"opt/*/lib/pkgconfig/*.pc").to_s) +
                      Dir.glob((HOMEBREW_PREFIX/"opt/*/lib64/pkgconfig/*.pc").to_s)
    pkgconfig_files.each { |pc| ln_sf pc, sdk_pkgconfig/File.basename(pc) }
    openssl_libdir = (libexec/"lib64/libcrypto.a").exist? ? libexec/"lib64" : libexec/"lib"
    openssl_version = Utils.safe_popen_read(libexec/"bin/openssl", "version").split[1]
    rm sdk_pkgconfig/"openssl.pc" if (sdk_pkgconfig/"openssl.pc").exist?
    (sdk_pkgconfig/"openssl.pc").write <<~PC
      prefix=#{libexec}
      libdir=#{openssl_libdir}
      includedir=#{libexec}/include
      Name: OpenSSL
      Description: Frida's QUIC-enabled OpenSSL fork
      Version: #{openssl_version}
      Libs: -L${libdir} -lssl -lcrypto
      Cflags: -I${includedir}
    PC
    %w[lib/pkgconfig lib64/pkgconfig].each do |subdir|
      (libexec/subdir).glob("*.pc").each do |pc|
        next if pc.basename.to_s == "openssl.pc"

        ln_sf pc, sdk_pkgconfig/pc.basename
      end
    end
    %w[lib lib64].each do |subdir|
      source = HOMEBREW_PREFIX/subdir
      next unless source.directory?

      destination = sdk/subdir
      destination.mkpath
      source.children.each do |entry|
        next if entry.directory?

        ln_sf entry, destination/entry.basename
      end
    end
    source = HOMEBREW_PREFIX/"include"
    if source.directory?
      destination = sdk/"include"
      destination.mkpath
      source.children.each do |entry|
        ln_sf entry, destination/entry.basename
      end
    end
    (sdk/"VERSION.txt").write("#{deps_version}\n")
    ENV.prepend_path "PKG_CONFIG_PATH", sdk_pkgconfig
    ENV["PKG_CONFIG_LIBDIR"] = sdk_pkgconfig.to_s
    ENV["FRIDA_DEPS"] = frida_deps.to_s
    openssl_pcdir = Utils.safe_popen_read("pkg-config", "--variable=pcfiledir", "openssl").strip
    if openssl_pcdir != sdk_pkgconfig.to_s
      odie "Frida OpenSSL pkg-config metadata was not selected"
    end

    # Keep generated GIR files inside the formula prefix rather than modifying
    # the gobject-introspection dependency during install.
    pkgconfig = buildpath/"pkgconfig"
    pkgconfig.mkpath
    gi_pc = pkgconfig/"gobject-introspection-1.0.pc"
    cp formula_opt_lib("gobject-introspection")/"pkgconfig/gobject-introspection-1.0.pc", gi_pc
    inreplace gi_pc,
      "girdir=${datadir}/gir-1.0", "girdir=#{share}/gir-1.0"
    inreplace gi_pc,
      "typelibdir=${libdir}/girepository-1.0", "typelibdir=#{lib}/girepository-1.0"
    ENV.prepend_path "PKG_CONFIG_PATH", pkgconfig

    system "./configure", "--prefix=#{prefix}", "--without-prebuilds=sdk,toolchain", "--",
                          "-Dwrap_mode=nodownload",
                          "-Dfrida-core:compat_force_fallback_for=glib-2.0,gee-0.8,json-glib-1.0,nice,libsoup-3.0",
                          "-Dfrida_tools=disabled",
                          "-Dfrida_node=disabled",
                          "-Dfrida_swift=disabled",
                          "-Dfrida_clr=disabled",
                          "-Dfrida_qml=disabled",
                          "-Dfrida_python=enabled"
    system "make"
    system "make", "install"

    # Meson prepends the formula prefix to Python's absolute site-packages path.
    # Relocate the generated extension to Homebrew's standard Python site path.
    site_packages = lib/"python3.14/site-packages"
    meson_site_packages = prefix/HOMEBREW_PREFIX.relative_path_from(Pathname("/"))/"lib/python3.14/site-packages"
    site_packages.mkpath
    mv meson_site_packages/"frida", site_packages/"frida"
    rm_r libexec

    rm_r include/"libusb-1.0" if (include/"libusb-1.0").exist?
    rm_r include/"quickjs" if (include/"quickjs").exist?
    rm_r include/"libdwarf" if (include/"libdwarf").exist?
    rm_r include/"tinycc" if (include/"tinycc").exist?
  end

  test do
    system "python3.14", "-c", <<~PY
      import os
      import subprocess
      import frida
      device = frida.get_local_device()
      params = device.query_system_parameters()
      assert params["platform"] in {"linux", "darwin"}
      assert params["arch"]
      assert any(process.pid == os.getpid() for process in device.enumerate_processes())

      if params["platform"] == "linux":
          process = subprocess.Popen(["/bin/sleep", "30"])
          session = None
          try:
              session = device.attach(process.pid)
              script = session.create_script("rpc.exports = { answer() { return 42; } };")
              script.load()
              assert script.exports_sync.answer() == 42
          finally:
              if session is not None:
                  session.detach()
              process.terminate()
              process.wait()
    PY
  end
end
