class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  # TODO: Revert back to PyPI url on next version bump and remove livecheck
  url "https://github.com/jarun/buku/archive/refs/tags/v5.1.tar.gz"
  sha256 "0f1a3e15f882fe9a0f8e550abae7388d3cb81d4718a1b4309dcf4363633cb7b1"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/jarun/buku.git", branch: "master"

  livecheck do
    url "https://pypi.org/pypi/buku/json"
    strategy :json do |json|
      json.dig("info", "version")
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59c422dd91e2597a9b6587a296b50eaa6f13e77dea7670f45c3c5f4f9a46b51f"
    sha256 cellar: :any, arm64_sequoia: "57e550f4582ff9096241744e786a267fa326f45fd94b9af766cd63d40c7f01a4"
    sha256 cellar: :any, arm64_sonoma:  "a4842de8dd5348d601168af329dd80f763b29b7e54b98e2e473855176386f849"
    sha256 cellar: :any, sonoma:        "f058ca566cc9e115513f272e8f407a57135eaa9667595a09387966c6122a7671"
    sha256 cellar: :any, arm64_linux:   "be1dadf4e8c2791f122bc1ded834ded6fa14fb762452630ae9c78392cfa6ff8b"
    sha256 cellar: :any, x86_64_linux:  "5293e68aa3306349d0eec6ef4faf8c3dd1dea67d75c5a9064ff44d4afa1fa62c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
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
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/61/08/63770603ea3184782d6996455dcf9520893db58e9bd9f3e346b52d91fcea/flask_admin-2.2.0.tar.gz"
    sha256 "4a5b844789c10076da89320563600a7addf781e73ab315ae800521b3ec018509"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/7b/a5/2dab368d6950e6808904dec98f54c7e726ee7be4a0c6afe00e6e011bd52d/mistune-3.3.3.tar.gz"
    sha256 "c4c6c0c840b8637a2e9b8b6d607eb7c8f00888bf14c754409bcd339e848c2477"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
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
