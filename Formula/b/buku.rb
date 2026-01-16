class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  # TODO: Revert back to PyPI url on next version bump
  url "https://github.com/jarun/buku/archive/refs/tags/v5.1.tar.gz"
  sha256 "0f1a3e15f882fe9a0f8e550abae7388d3cb81d4718a1b4309dcf4363633cb7b1"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jarun/buku.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "978988301396ed5a6e48b95a2804238b625683614b4fb05115416cdc906f9cf6"
    sha256 cellar: :any,                 arm64_sequoia: "e7d8bd71d4cb5313a7e7ced4c190cd0161c2bb1d62ba5a183146d88958dd85eb"
    sha256 cellar: :any,                 arm64_sonoma:  "4eb6363c9ed04dc7b69507c67ee2d6bdb62edb103b5041ac1c286ff61e4d8e24"
    sha256 cellar: :any,                 sonoma:        "3ae7dc4aa6d1f0c72e35fda5d158b06d56af52282ac3901c0b2cfa702eea3248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb2e5af49d5b6bfdb1eded592ac04c90ffbee7ab3795c9b0c0293fd91e669d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05530c0c8b99247e64f2bc2b361951ea2568b339b1250af3f87ce6bb9dd2e9e0"
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
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "flasgger" do
    url "https://files.pythonhosted.org/packages/8a/e4/05e80adeadc39f171b51bd29b24a6d9838127f3aaa1b07c1501e662a8cee/flasgger-0.9.7.1.tar.gz"
    sha256 "ca098e10bfbb12f047acc6299cc70a33851943a746e550d86e65e60d4df245fb"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-admin" do
    url "https://files.pythonhosted.org/packages/cc/b7/78a1534b4fe1a40bccf79e8e274e1ace6ee1678c804e4c178b1c96e6c8d6/flask_admin-2.0.2.tar.gz"
    sha256 "1d06aec7efee957972b43f6b08a0bd08d5f4cf9a337d4ece2f17c98abc2a214e"
  end

  resource "flask-paginate" do
    url "https://files.pythonhosted.org/packages/5c/d0/aca9153b109f0062eaadb497448f5e596f87cc89474d77347a1d931c8842/flask-paginate-2024.4.12.tar.gz"
    sha256 "2de04606b061736f0fc8fbe73d9d4d6fc03664638eca70a57728b03b3e2c9577"
  end

  resource "flask-wtf" do
    url "https://files.pythonhosted.org/packages/80/9b/f1cd6e41bbf874f3436368f2c7ee3216c1e82d666ff90d1d800e20eb1317/flask_wtf-1.2.2.tar.gz"
    sha256 "79d2ee1e436cf570bccb7d916533fa18757a2f18c290accffab1b9a0b684666b"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
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
    url "https://files.pythonhosted.org/packages/9d/55/d01f0c4b45ade6536c51170b9043db8b2ec6ddf4a35c7ea3f5f559ac935b/mistune-3.2.0.tar.gz"
    sha256 "708487c8a8cdd99c9d90eb3ed4c3ed961246ff78ac82f03418f5183ab70e398a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/89/23/adf3796d740536d63a6fbda113d07e60c734b6ed5d3058d1e47fc0495e47/soupsieve-2.8.1.tar.gz"
    sha256 "4cf733bc50fa805f5df4b8ef4740fc0e0fa6218cf3006269afd3f9d6d80fd350"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/5a/70/1469ef1d3542ae7c2c7b72bd5e3a4e6ee69d7978fa8a3af05a38eca5becf/werkzeug-3.1.5.tar.gz"
    sha256 "6a548b0e88955dd07ccb25539d7d0cc97417ee9e179677d22c7041c8f078ce67"
  end

  resource "wtforms" do
    url "https://files.pythonhosted.org/packages/01/e4/633d080897e769ed5712dcfad626e55dbd6cf45db0ff4d9884315c6a82da/wtforms-3.2.1.tar.gz"
    sha256 "df3e6b70f3192e92623128123ec8dca3067df9cfadd43d59681e210cfb8d4682"
  end

  # Fix type error and missing apidocs: https://github.com/jarun/buku/pull/883
  patch do
    url "https://github.com/jarun/buku/commit/291fa9a0e4cafe9ca2261940394de12c2d5403a9.patch?full_index=1"
    sha256 "ba678c0814589954817da53907399736c1d2e989a875a0957fc8ef8bad706164"
  end
  patch do
    url "https://github.com/jarun/buku/commit/ea0a44a1c20821bd925a3557efabb8905db4337b.patch?full_index=1"
    sha256 "76fea0fcbaec25376722f598a8dd12012245a650c37f867e27f19dcfa8e43963"
  end

  def install
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
    assert_match "The missing package manager for macOS", result

    # Test bukuserver
    result = shell_output("#{bin}/bukuserver --version")
    assert_match version.to_s, result

    port = free_port
    pid = spawn bin/"bukuserver", "run", "--host", "127.0.0.1", "--port", port.to_s, [:out, :err] => File::NULL

    begin
      sleep 15
      result = shell_output("curl -s 127.0.0.1:#{port}/api/bookmarks")
      assert_match "https://github.com/Homebrew/brew", result
      assert_match "The missing package manager for macOS", result
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
