class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  # TODO: Revert back to PyPI url on next version bump and remove livecheck
  url "https://github.com/jarun/buku/archive/refs/tags/v5.1.tar.gz"
  sha256 "0f1a3e15f882fe9a0f8e550abae7388d3cb81d4718a1b4309dcf4363633cb7b1"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/jarun/buku.git", branch: "master"

  livecheck do
    url "https://pypi.org/pypi/buku/json"
    strategy :json do |json|
      json.dig("info", "version")
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7745577563ca5da5fe49b9fe3db472b80c1fb1b0b1cd6411f87d500f359dc1f9"
    sha256 cellar: :any, arm64_tahoe:       "8f25d4e1eaac7be11043050ec562cea552fbdd50ccbf7585b12f63b8de30fccc"
    sha256 cellar: :any, arm64_sequoia:     "4f37f749eb029b33a7a24f7c621089fd14912f56fe9f1eaad35aceee94a45841"
    sha256 cellar: :any, arm64_linux:       "2c378de29ad71a415dac7eaa0af1d1e2a9cae9f355a7a2bb224b9792a6f3d731"
    sha256 cellar: :any, x86_64_linux:      "47df1b8e33c52f0f2c86deebadbb1fe3d100f121d849e3c9ca0d0ba84d64b7f6"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py"

  uses_from_macos "libffi"

  pypi_packages package_name:     "buku[server]",
                exclude_packages: ["certifi", "cryptography", "rpds-py"]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "flasgger" do
    url "https://files.pythonhosted.org/packages/8a/e4/05e80adeadc39f171b51bd29b24a6d9838127f3aaa1b07c1501e662a8cee/flasgger-0.9.7.1.tar.gz"
    sha256 "ca098e10bfbb12f047acc6299cc70a33851943a746e550d86e65e60d4df245fb"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "flask-admin" do
    url "https://files.pythonhosted.org/packages/08/86/92b2f706fa49a06a546381e809d84a082f70fe782f6f2d50a72e185422ae/flask_admin-2.2.1.tar.gz"
    sha256 "08b4b6b63d2100598add70c1dc9a695f484e3c16c894c09ac70af26acb26a87d"
  end

  resource "flask-paginate" do
    url "https://files.pythonhosted.org/packages/5c/d0/aca9153b109f0062eaadb497448f5e596f87cc89474d77347a1d931c8842/flask-paginate-2024.4.12.tar.gz"
    sha256 "2de04606b061736f0fc8fbe73d9d4d6fc03664638eca70a57728b03b3e2c9577"
  end

  resource "flask-wtf" do
    url "https://files.pythonhosted.org/packages/91/f1/605a56d4ea217b307f3e6f4d663e0351253d85d841edc93ba559f0648e19/flask_wtf-1.3.0.tar.gz"
    sha256 "61d5dabc50c3df885c297dcbd80810443a5d632106c8a69cab8ce740f0cdd7cc"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/issues/588"
    end
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/7b/92/328a294a6de83bacb95bed01f04e0eaff4e3616ee359fc821a5dfc539b02/mistune-3.3.4.tar.gz"
    sha256 "58b5c96d6fcb61190dfe5fae498d2b2065f99cf61e9649418fd54cf1ada86dfe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  resource "wtforms" do
    url "https://files.pythonhosted.org/packages/e9/91/ed9b517da898e3fb747566aa3c12a734bd64ea7449a0d25ec74ce8f8b8eb/wtforms-3.2.2.tar.gz"
    sha256 "7b00c73f8670f35d4edb0293dcd81b980528bee72fd662b182aaba27ae570b93"
  end

  # Fix type error and missing apidocs
  patch do
    url "https://github.com/jarun/buku/commit/8ea88ad2685c57700861c65c16f200324a7f09b0.patch?full_index=1"
    sha256 "0fb66c7b239e787c57d9a374769d3339c002609404c3ddd192e26cb982cdafe0"
    type :backport
    resolves "https://github.com/jarun/buku/pull/883"
  end

  def install
    # Workaround for https://github.com/html5lib/html5lib-python/issues/593
    odie "Check if setuptools workaround can be removed!" if resource("html5lib").version > "1.1.0"
    (buildpath/"build-constraints.txt").write "setuptools<82\n"
    ENV["PIP_BUILD_CONSTRAINT"] = buildpath/"build-constraints.txt"

    virtualenv_install_with_resources
    bash_completion.install "auto-completion/bash/buku-completion.bash" => "buku"
    fish_completion.install "auto-completion/fish/buku.fish"
    zsh_completion.install "auto-completion/zsh/_buku"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["XDG_DATA_HOME"] = "#{testpath}/.local/share"

    # Firefox exported bookmarks file
    (testpath/"bookmarks.html").write <<~HTML
      <!DOCTYPE NETSCAPE-Bookmark-file-1>
      <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
      <TITLE>Bookmarks</TITLE>
      <H1>Bookmarks Menu</H1>

      <DL><p>
          <HR>    <DT><H3 ADD_DATE="1464091987" LAST_MODIFIED="1477369518" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks Toolbar</H3>
          <DD>Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar
          <DL><p>
              <DT><A HREF="https://github.com/Homebrew/brew" ADD_DATE="1477369518" LAST_MODIFIED="1477369529">Title unknown</A>
          </DL><p>
      </DL>
    HTML

    system bin/"buku", "--nostdin", "--nc", "--tacit", "--import", "bookmarks.html"
    assert_equal <<~EOS, shell_output("#{bin}/buku --nostdin --nc --print").chomp
      1. Title unknown
         > https://github.com/Homebrew/brew
    EOS

    # Test online components -- fetch titles
    assert_match "Index 1: updated", shell_output("#{bin}/buku --nostdin --nc --update")

    # Test crypto functionality
    require "expect"
    require "pty"
    timeout = 5
    PTY.spawn(bin/"buku", "--lock") do |r, w, pid|
      # Lock bookmark database
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "password\r"
      refute_nil r.expect("Password: ", timeout), "Expected password confirmation input"
      w.write "password\r"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      refute_match "ERROR", output
      assert_match "File encrypted", output
    ensure
      r.close
      w.close
      Process.wait pid
    end
    PTY.spawn(bin/"buku", "--unlock") do |r, w, pid|
      # Unlock bookmark database
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "password\r"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      refute_match "ERROR", output
      assert_match "File decrypted", output
    ensure
      r.close
      w.close
      Process.wait pid
    end

    # Test database content and search
    result = shell_output("#{bin}/buku --np --sany Homebrew")
    assert_match "https://github.com/Homebrew/brew", result

    # Test bukuserver
    assert_match version.to_s, shell_output("#{bin}/bukuserver --version")

    port = free_port
    pid = spawn bin/"bukuserver", "run", "--host", "127.0.0.1", "--port", port.to_s, [:out, :err] => File::NULL

    begin
      result = shell_output("curl -s --retry 5 --retry-connrefused 127.0.0.1:#{port}/api/bookmarks")
      assert_match "https://github.com/Homebrew/brew", result
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
