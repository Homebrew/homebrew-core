class Buku < Formula
  include Language::Python::Virtualenv

  desc "Powerful command-line bookmark manager"
  homepage "https://github.com/jarun/buku"
  url "https://files.pythonhosted.org/packages/a0/74/a3ecd735d75fc452fa4c6a995141cda20937e21d30ae9810d70ed159f58d/buku-5.0.tar.gz"
  sha256 "895a86b099adfe420c1925f333ce6cb00b851a6f11bcc7e42fb125fa81cae8b2"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jarun/buku.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a1f1557ab3d6578e9589b8e28fc2477ab3ec5fc3224bb5c7f9f81fc69e830b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f94f9b0dc834181746d00e206d9fc50d4f330602acc33d7ea9b9eadcbec0c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc3e4e855f52937e2afcfa149e41eeb3dc313e9f54bbb997bf6b312e0957838"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0fa70a3343c56a5c94ae4c0f22d24346e281fa56c3bbdfd1504942a28464319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bd708874bf13051728a3c67e18dfb804860024005b049cfd57a15c13a5da4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3faf4630b940657022c532f496614567061a255234b18fb397530aa5acf36ef3"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages package_name:     "buku[server]",
                exclude_packages: ["certifi", "cryptography"]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-admin" do
    url "https://files.pythonhosted.org/packages/be/4d/7cad383a93e3e1dd9378f1fcf05ddc532c6d921fb30c19ce8f8583630f24/Flask-Admin-1.6.1.tar.gz"
    sha256 "24cae2af832b6a611a01d7dc35f42d266c1d6c75a426b869d8cb241b78233369"
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

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/fc/83/24ed25dd0c6277a1a170c180ad9eef5879ecc9a4745b58d7905a4588c80d/types_python_dateutil-2.9.0.20251008.tar.gz"
    sha256 "c3826289c170c93ebd8360c3485311187df740166dbab9dd3b792e69f2bc1f9c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wtforms" do
    url "https://files.pythonhosted.org/packages/01/e4/633d080897e769ed5712dcfad626e55dbd6cf45db0ff4d9884315c6a82da/wtforms-3.2.1.tar.gz"
    sha256 "df3e6b70f3192e92623128123ec8dca3067df9cfadd43d59681e210cfb8d4682"
  end

  def install
    virtualenv_install_with_resources
    man1.install "buku.1"
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
    pid = fork do
      $stdout.reopen(File::NULL)
      $stderr.reopen(File::NULL)
      exec "#{bin}/bukuserver", "run", "--host", "127.0.0.1", "--port", port.to_s
    end

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
