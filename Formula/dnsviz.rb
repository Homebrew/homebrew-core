class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://github.com/dnsviz/dnsviz/releases/download/v0.6.7/dnsviz-0.6.7.tar.gz"
  sha256 "b94f06afb78754ef70597b214a3bd29c0d2f1fd1478ddc8bdd35edc372703ce2"

  bottle do
    cellar :any
    sha256 "a8616dd78b6f1c08fd8f22d836223d55c40122de093c9c5e804dc5707365bfb4" => :mojave
    sha256 "af19e811f005a5fde01489c7364fe8cd9d98467466ccb4d215e2aac9799ce967" => :high_sierra
    sha256 "b5e94daf80161fc321668a9f63062a0e4b994fec5e020a60e133686dde81fadd" => :sierra
    sha256 "fabdeb85ef8745e3c1fb3a56efb44b0d583c3833a9c20200da193a0055b335b8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "openssl"
  depends_on "python@2"
  depends_on "bind" => :optional

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/98/bb/a32e33f7665b921c926209305dde66fe41003a4ad934b10efb7c1211a419/pygraphviz-1.3.1.tar.gz"
    sha256 "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408"
  end

  resource "m2crypto" do
    url "https://files.pythonhosted.org/packages/11/29/0b075f51c38df4649a24ecff9ead1ffc57b164710821048e3d997f1363b9/M2Crypto-0.26.0.tar.gz"
    sha256 "05d94fd9b2dae2fb8e072819a795f0e05d3611b09ea185f68e1630530ec09ae8"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/17/75/3698d7992a828ad6d7be99c0a888b75ed173a9280e53dbae67326029b60e/typing-3.6.1.tar.gz"
    sha256 "c36dec260238e7464213dcd50d4b5ef63a507972f5780652e835d0228d0edace"
  end

  def install
    venv = virtualenv_create(libexec)
    resource("m2crypto").stage do
      system libexec/"bin/python", "setup.py", "build_ext", "--openssl=#{Formula["openssl"].opt_prefix}", "install"
    end
    venv.pip_install resources.reject { |r| r.name == "m2crypto" }
    system libexec/"bin/python", "setup.py", "build"
    system libexec/"bin/python", "setup.py", "install", "--prefix=#{libexec}", "--install-data=#{prefix}", "--install-scripts=#{bin}"
  end

  test do
    message_1 = <<~EOS
      6heBoAABAA4AAAABAAACAAEAAAIAAQAAQEQAFAFqDHJvb3Qtc2VydmVycwNuZXQAAAACAAEAA
      EBEAAQBZsAeAAACAAEAAEBEAAQBa8AeAAACAAEAAEBEAAQBZcAeAAACAAEAAEBEAAQBZMAeAA
      ACAAEAAEBEAAQBacAeAAACAAEAAEBEAAQBaMAeAAACAAEAAEBEAAQBY8AeAAACAAEAAEBEAAQ
      BZ8AeAAACAAEAAEBEAAQBYsAeAAACAAEAAEBEAAQBbMAeAAACAAEAAEBEAAQBYcAeAAACAAEA
      AEBEAAQBbcAeAAAuAAEAAEBEARMAAggAAAfpAFgqllBYGWTAmXsAco8uPM6BjFcEV4KkRvruu
      C/2W4UHu5GcXkZKs9SbBc4i7KHFM+oyr4IPBZiNUEtn9L7rKJxyRdas+y3+uFld4jy7r0nhsx
      cQnsQ1KvpwQPGJfzZnHYqSLofyXx2v3zWp1TItBHA4719vgGbj0ZsbnsonyvZt6N+t8cF0rFK
      s2eWWcSwSFRGOOvxw2shQsvxQhDw4hC1jxkiG94xhJCbhZcmJq3DEc27I25amDYik9NkYROgf
      mIA9+UcsmJ0tFJ0u4OBS6JN9iMomPOXcPFz/ZF3wGdCV1Jcx3Kj3ytOX2XccjAMF4kvbwx2/U
      +pEm1xBDebTTOXC8biZ6gHF3AVRFgAAKQIAAACAAAAA
    EOS

    message_2 = <<~EOS
      rQmBoAABAAIAAAABAAAGAAEAAAYAAQAATiEAQAFhDHJvb3Qtc2VydmVycwNuZXQABW5zdGxkD
      HZlcmlzaWduLWdycwNjb20AeCtmeAAABwgAAAOEAAk6gAABUYAAAC4AAQAATiEBEwAGCAAAAV
      GAWCqWUFgZZMCZewAlgFTcjso0WCaN8gG1M1bAGce8KhyDRZsYGIHzMpJmSZyB6TIJMuFq+/a
      9VDqDXcUq5F3EVjppXN8v8yLYMUoQmW3JmkXMlH/70ID2AImRVciDFhQO48WY4wgq1lhRe/nx
      mp7Qxvk8b2G4BQma4Qkel4f/UAaFogDpv7DtTfvQydDi8ZcduN2MbDiQqZZCV/CPGf2ekJZX7
      YRrC3j+VfLfyck5VFv2xzzP7aWxtpzhk7L4xeGvDsmbaiU0xNb+oq+mhw7SU1AZLsQUhXe3v1
      uxFlhMc0au6BSskHwDIsaNX/cS+8NM1DsNU7neZNzHteekzKcHpwcJhfJx+GS/XtKAAAApAgA
      AAIAAAAA=
    EOS

    # message_3 is inlined because it is not >80 characters.
    message_4 = <<~EOS
      ex6BoAABAAMAAAABAAAwAAEAADAAAQAAM3wBCAEBAwgDAQABqAAgqVVmukLohruATNqE5H71b
      b167GEmFVUs7JBtIRbQ7yBwKMUVVBRN/q/nx8uPAF3RgjQTOsBxCoEYLOH9FK0ig7yDQ1+d8v
      YxMlGTGhdt8NpR5U9C5gSGDfs1lYAlD1WcxUPE/9Ucvj3oz9BnGSN/n8R+5ynaBoNfpFLoJem
      hjrwuy89WNHRlLDPPVqkDO8312XMSF5fsgIkEG24DobctCnNbmE4DaHMJMyMk8nwtuoXp2xXo
      OgFDOC6XSwYhwY5iXs7JB1d9nnut6VJBqB676KkB1NMnbkCxFMCi5vw40ZwuaqsCZEsoE/V1/
      CFgHg3uSc2e6WpDED5STWKHPQAAMAABAAAzfAEIAQADCAMBAAGG4p2rhwPaFG+GhjbSSK3qch
      qGMtDi9Na7yIb6N0VjfwofKdguGRJKb1GJMe+K/SaYKzrIyjr/iUHSrU9rvAMRo1KB/MfB3aQ
      4jFe156ViaPcAMZRbQ7WzJz8EUN3VrE9aeZsqxnJuxBSfY+ypogBBuYRrHr2anJ6jDlvUBZJq
      f8zNExWF2FqugLAKH9rmai1MnfpxyFtExrGhzM3EzXwPFsPjmFe0eG3Ef/HnQhKOjgIfY+PEd
      YUbbjtXtjEHZ5CE3PQyZYweAqtYECsL/5Lu5gL5hblpEaLTGSBTd7w4aZqZsuzNAtRB0kQID/
      h5G5S0UCjj58CP1ZLCRFOH5p4ZAAAuAAEAADN8ARMAMAgAAAKjAFgqT/9YFomASlwALPuldf5
      oWFdSHSTPYL5WvrvwJTElxY6LTEw2Cit0JOcVAbZG6LLCmlpCJ55Ngf/sdE4UXUPJ/m6CFRYT
      +aAePvEWrjRPGGX64V82oCeCPyAqD4XHd3CIQi3LBYk8ZbEktyvBX+VS16rbSEQib7xNYvoht
      iJ0dRiw/wjr6YVF8xUdYO1vvXPYOGXISYwW4vDiKAuyLDGuoLRh/F9GZQxBPwv6Bmx8/JfNCf
      IygbnZ/8qIZUsFH68DPbAHPBqwR1GP+haAa6vQPhXwn4p+Vci7rYNzfPzdQfDNWsQ+8ur8xxS
      danAZcZRrytaidLtIQx4DeGANdwmNjnAn8ZSg6q8etQAAKQIAAACAAAAA
    EOS

    (testpath/"test.json").write <<~EOS
      {
        ".": {
          "type": "recursive",
          "stub": false,
          "analysis_start": "2016-11-02 16:00:37 UTC",
          "analysis_end": "2016-11-02 16:00:37 UTC",
          "clients_ipv4": [
            "127.0.0.1"
          ],
          "clients_ipv6": [],
          "explicit_delegation": true,
          "auth_ns_ip_mapping": {
            "ns1.": [
              "127.0.0.1"
            ]
          },
          "queries": [
            {
              "qname": ".",
              "qclass": "IN",
              "qtype": "NS",
              "options": {
                "flags": 256,
                "edns_version": 0,
                "edns_max_udp_payload": 4096,
                "edns_flags": 32768,
                "edns_options": [],
                "tcp": false
              },
              "responses": {
                "127.0.0.1": {
                  "127.0.0.1": {
                    "message": "#{message_1.delete!("\n")}",
                    "msg_size": 525,
                    "time_elapsed": 25,
                    "history": []
                  }
                }
              }
            },
            {
              "qname": ".",
              "qclass": "IN",
              "qtype": "SOA",
              "options": {
                "flags": 256,
                "edns_version": 0,
                "edns_max_udp_payload": 4096,
                "edns_flags": 32768,
                "edns_options": [],
                "tcp": false
              },
              "responses": {
                "127.0.0.1": {
                  "127.0.0.1": {
                    "message": "#{message_2.delete!("\n")}",
                    "msg_size": 389,
                    "time_elapsed": 26,
                    "history": []
                  }
                }
              }
            },
            {
              "qname": ".",
              "qclass": "IN",
              "qtype": "DNSKEY",
              "options": {
                "flags": 256,
                "edns_version": 0,
                "edns_max_udp_payload": 512,
                "edns_flags": 32768,
                "edns_options": [],
                "tcp": false
              },
              "responses": {
                "127.0.0.1": {
                  "127.0.0.1": {
                    "message": "Z/ODgAABAAAAAAABAAAwAAEAACkCAAAAgAAAAA==",
                    "msg_size": 28,
                    "time_elapsed": 38,
                    "history": []
                  }
                }
              }
            },
            {
              "qname": ".",
              "qclass": "IN",
              "qtype": "DNSKEY",
              "options": {
                "flags": 256,
                "edns_version": 0,
                "edns_max_udp_payload": 4096,
                "edns_flags": 32768,
                "edns_options": [],
                "tcp": false
              },
              "responses": {
                "127.0.0.1": {
                  "127.0.0.1": {
                    "message": "#{message_4.delete!("\n")}",
                    "msg_size": 864,
                    "time_elapsed": 30,
                    "history": []
                  }
                }
              }
            }
          ]
        },
        "_meta._dnsviz.": {
          "version": 1.1,
          "names": [
            "."
          ]
        }
      }
    EOS
    system "#{bin}/dnsviz", "graph", "-Thtml", "-O", "-r", "test.json"
  end
end
